from flask import Flask, jsonify, request
import mysql.connector, json, os, subprocess
from dotenv import load_dotenv
from werkzeug.security import generate_password_hash, check_password_hash

# Load secrets from .env or .env.local if running locally
load_dotenv(".env")
if os.path.exists(".env.local"):
    load_dotenv(".env.local", override=True)
    env_file = ".env.local"
else:
    env_file = ".env"

cobol_path = os.path.join(os.path.dirname(__file__), "../cobol/build")

# Connect to the database helper
def get_db_connection():
    # print("Connecting to DB with the following parameters:")
    # print(".env path: ", env_file)
    # print(f"Host: {os.getenv('FIVEJARS_DB_HOST', 'localhost')}")
    # print(f"User: {os.getenv('FIVEJARS_MYSQL_USER', 'root')}")
    # print(f"Database: {os.getenv('FIVEJARS_MYSQL_DATABASE')}")
    # print(f"Password: {os.getenv('FIVEJARS_MYSQL_USER_PASSWORD') or os.getenv('FIVEJARS_MYSQL_ROOT_PASSWORD')}")
    # print(f"Port: {os.getenv('FIVEJARS_DB_PORT', 3306)}")
    return mysql.connector.connect(
        host=os.getenv("FIVEJARS_DB_HOST", "localhost"),
        user=os.getenv("FIVEJARS_MYSQL_USER", "root"),
        password=os.getenv("FIVEJARS_MYSQL_USER_PASSWORD") or os.getenv("FIVEJARS_MYSQL_ROOT_PASSWORD"),
        database=os.getenv("FIVEJARS_MYSQL_DATABASE"),
        port=os.getenv("FIVEJARS_DB_PORT", 3306)
    )

app = Flask(__name__)

# ======================================================================================================================

@app.route("/")
def index():
    return jsonify({
        "service": "5Jars Backend",
        "status": "ok"
        }
    ), 200

# ======================================================================================================================

@app.route("/coboltest")
def cobol_test():
    # Run the COBOL program and capture output
    binary_path = os.path.join(cobol_path, "test")
    try:
        result = subprocess.run([binary_path], capture_output=True, text=True, check=True)
        output = result.stdout
        return jsonify({"success": True, "output": output})
    except subprocess.CalledProcessError as e:
        return jsonify({"success": False, "error": e.stderr})

# ======================================================================================================================

@app.route("/users", methods=["GET"])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    conn.close()
    return jsonify(users)

# ======================================================================================================================

@app.route("/users/<int:user_id>", methods=["POST"])
def get_user_by_id():
    data = request.get_json()
    if not data or not all (field in data for field in ("user_id", "password_hash")):
        return jsonify({
            "success": False,
            "error": "Missing or incomplete required fields."
            }
        ), 206
    
    user_id = data["user_id"]
    password_hash = data["password_hash"]
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT * FROM users WHERE id = %s AND password_hash = %s",
            (user_id, password_hash)
        )
        user = cursor.fetchone()
        conn.close()
        if user:
            return jsonify({
                "success": True,
                "user": {
                    "id": user["id"],
                    "username": user["username"],
                    "nickname": user["nickname"]
                }
            }), 202
        else:
            return jsonify({
                "success": False,
                "error": "User not found or invalid credentials."
                }
            ), 404
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
            }
        ), 500
    
# ======================================================================================================================

@app.route("/users", methods=["POST"])
def add_user():
    data = request.get_json()
    if not data or not all(field in data for field in ("username", "nickname", "password")):
        return jsonify({
            "success": False,
            "error": "Missing or incomplete required fields."
            }
        ), 206
    
    username = data["username"]
    nickname = data["nickname"]
    password_hash = generate_password_hash(data["password"])

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO users (username, nickname, password_hash) VALUES (%s, %s, %s)",
            (username, nickname, password_hash)
        )
        conn.commit()
        new_user_id = cursor.lastrowid
        conn.close()
        return jsonify({
            "success": True,
            "new_user_id": new_user_id
            }
        ), 201
    except mysql.connector.IntegrityError:
        return jsonify({
            "success": False,
            "error": "Username already exists."
            }
        ), 409
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
            }
        ), 500
    
# ======================================================================================================================
    
@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    if not data or not all(field in data for field in ("username", "password")):
        return jsonify({
            "success": False,
            "error": "Missing or incomplete required fields."
            }
        ), 206

    username = data["username"]
    password = data["password"]

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT * FROM users WHERE username = %s",
            (username,) # Comma makes this a tuple (:/)
        )
        user = cursor.fetchone()
        conn.close()

        # Check pass
        if user and check_password_hash(user["password_hash"], password):
            return jsonify({
                "success": True,
                "user": {
                    "id": user["id"],
                    "username": user["username"],
                    "nickname": user["nickname"]
                }
            }), 202
        else:
            return jsonify({
                "success": False,
                "error": "Invalid username or password."
                }
            ), 401
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
            }
        ), 500

# ======================================================================================================================

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
