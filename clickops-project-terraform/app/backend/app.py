from flask import Flask, request, jsonify
from flask_cors import CORS
import boto3
import os
import json
from pymongo import MongoClient
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)

# AWS config
region = os.getenv("AWS_REGION")
secret_name = os.getenv("SECRET_NAME")

# Secrets Manager
sm = boto3.client("secretsmanager", region_name=region)

secret = sm.get_secret_value(SecretId=secret_name)
creds = json.loads(secret["SecretString"])

# MongoDB
client = MongoClient(f"mongodb://{os.getenv('MONGO_HOST')}:{os.getenv('MONGO_PORT')}")
db = client["clickops"]
collection = db["users"]

# S3
s3 = boto3.client("s3", region_name=region)
bucket = creds["bucket"]

@app.route("/")
def home():
    return jsonify({"message": "Welcome from backend 🚀"})

@app.route("/add", methods=["POST"])
def add():
    name = request.form.get("name")
    age = request.form.get("age")
    file = request.files["image"]

    filename = secure_filename(file.filename)

    # upload to S3
    s3.upload_fileobj(file, bucket, filename)

    # save to MongoDB
    collection.insert_one({
        "name": name,
        "age": age,
        "image": filename
    })

    return jsonify({"message": "User added successfully 🎉"})

@app.route("/list", methods=["GET"])
def list_users():
    users = list(collection.find({}, {"_id": 0}))
    return jsonify(users)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)