import os, json
from flask import Flask, request, jsonify
import boto3
from pymongo import MongoClient

app = Flask(__name__)

# ✅ ENV (dev / qa / prd)
ENV = os.environ.get("ENV", "dev")

REGION = "ap-south-1"

# ✅ Dynamic names (NO hardcoding)
BUCKET = f"clickops-s3-{ENV}"
SECRET_NAME = f"clickops-sm-{ENV}"
DB_NAME = f"clickops-db-{ENV}"

# AWS clients
s3 = boto3.client("s3", region_name=REGION)
sm = boto3.client("secretsmanager", region_name=REGION)

# ✅ Get MongoDB details from Secrets Manager
secret = sm.get_secret_value(SecretId=SECRET_NAME)
data = json.loads(secret["SecretString"])

mongo_host = data["host"]
mongo_port = int(data["port"])

client = MongoClient(mongo_host, mongo_port)
db = client[DB_NAME]

@app.route("/")
def home():
    return f"ClickOps Backend Running in {ENV.upper()} 🚀"

# ✅ ADD ENTRY
@app.route("/add", methods=["POST"])
def add():
    name = request.form["name"]
    age = request.form["age"]
    file = request.files["image"]

    # upload to S3
    s3.upload_fileobj(file, BUCKET, file.filename)

    entry = {
        "name": name,
        "age": age,
        "image": file.filename
    }

    db.entries.insert_one(entry)

    return jsonify({
        "message": f"Welcome {name} to ClickOps ({ENV.upper()}) 🚀",
        "data": entry
    })

# ✅ LIST ENTRIES
@app.route("/list")
def list_data():
    data = list(db.entries.find({}, {"_id": 0}))
    return jsonify(data)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)