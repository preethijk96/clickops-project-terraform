from flask import Flask, request, jsonify
from flask_cors import CORS
import boto3
import os
from pymongo import MongoClient
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)

# ENV (dev / qa / prd)
env = os.getenv("ENV", "dev")

# MongoDB
client = MongoClient(f"mongodb://{os.getenv('MONGO_HOST')}:{os.getenv('MONGO_PORT')}")
db = client["clickops"]
collection = db["users"]

# S3 bucket mapping
bucket_map = {
    "dev": "clickops-bucket-dev",
    "qa": "clickops-bucket-qa",
    "prd": "clickops-bucket-prd"
}

bucket = bucket_map.get(env, "clickops-bucket-dev")

# S3 client
s3 = boto3.client("s3", region_name="ap-south-1")

@app.route("/")
def home():
    return jsonify({"message": f"Welcome from backend ({env}) 🚀"})

@app.route("/add", methods=["POST"])
def add():
    name = request.form.get("name")
    age = request.form.get("age")
    file = request.files["image"]

    filename = secure_filename(file.filename)

    # Upload to S3
    s3.upload_fileobj(file, bucket, filename)

    # Save to MongoDB
    collection.insert_one({
        "name": name,
        "age": age,
        "image": filename
    })

    return jsonify({"message": f"User added successfully in {env} 🎉"})

@app.route("/list", methods=["GET"])
def list_users():
    users = list(collection.find({}, {"_id": 0}))
    return jsonify(users)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)