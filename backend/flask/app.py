from flask import Flask, jsonify, request
import mysql.connector, json, os, subprocess
from dotenv import load_dotenv

# Load secrets from .env or .env.local if running locally
env_file = ".env.local" if os.path.exists(".env.local") else ".env"
load_dotenv(env_file)

cobol_path = os.path.join(os.path.dirname(__file__), "../cobol/build")

# Connect to the database helper
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("FIVEJARS_DB_HOST", "localhost"),
        user=os.getenv("FIVEJARS_MYSQL_USER", "root"),
        password=os.getenv("FIVEJARS_MYSQL_USER_PASSWORD") or os.getenv("FIVEJARS_MYSQL_ROOT_PASSWORD"),
        database=os.getenv("FIVEJARS_MYSQL_DATABASE"),
        port=os.getenv("FIVEJARS_DB_PORT", 3306)
    )

app = Flask(__name__)

@app.route("/")
def index():
    return jsonify({
        "message": "Flask running."
        })

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

@app.route("/users", methods=["GET"])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()
    conn.close()
    return jsonify(users)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
