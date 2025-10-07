from flask import Flask, jsonify, request
import mysql.connector, json, os, subprocess
from dotenv import load_dotenv

# Load secrets from .env
load_dotenv()

# Load non-secret DB config
config_path = os.path.join(os.path.dirname(__file__), "../db/db_config.json")
with open(config_path, "r") as f:
    cfg = json.load(f)

cobol_path = os.path.join(os.path.dirname(__file__), "../cobol/build")

# Connect to the database helper
def get_db_connection():
    return mysql.connector.connect(
        host=cfg["host"],
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD"),
        database=cfg["database"],
        port=os.getenv("DB_PORT", 3306)
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
    print(f"Running COBOL binary at: {binary_path}")
    try:
        result = subprocess.run([binary_path], capture_output=True, text=True, check=True)
        output = result.stdout
        print(f"COBOL Output: {output}")
    
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
    app.run(debug=True)
