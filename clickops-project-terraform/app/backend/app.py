from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import boto3
import os
import uuid

app = Flask(__name__)
CORS(app)

# ----------------------------------
# Dynamic Environment Configuration
# ----------------------------------

ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")

MONGO_HOST = os.getenv("MONGO_HOST", "mongodb-dev")
MONGO_URI = os.getenv("MONGO_URI", f"mongodb://{MONGO_HOST}:27017/")

DB_NAME = os.getenv("DB_NAME", f"clickops-{ENVIRONMENT}")
BUCKET_NAME = os.getenv("BUCKET_NAME", f"clickops-bucket-{ENVIRONMENT}")

AWS_REGION = os.getenv("AWS_REGION", "ap-south-1")


# ----------------------------------
# Mongo Connection
# ----------------------------------

client = MongoClient(MONGO_URI)
db = client[DB_NAME]
collection = db.users


# ----------------------------------
# S3 Connection
# ----------------------------------

s3 = boto3.client(
    "s3",
    region_name=AWS_REGION
)


# ----------------------------------
# Health Check
# ----------------------------------

@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "environment": ENVIRONMENT,
        "database": DB_NAME,
        "bucket": BUCKET_NAME,
        "mongo_host": MONGO_HOST
    })


# ----------------------------------
# Get Records
# ----------------------------------

@app.route("/list", methods=["GET"])
def list_students():

    students = []

    for doc in collection.find():
        students.append({
            "name": doc["name"],
            "age": doc["age"],
            "image": doc["image"]
        })

    return jsonify(students)


# ----------------------------------
# Add Record + Upload Image to S3
# ----------------------------------

@app.route("/add", methods=["POST"])
def add_student():

    try:
        name = request.form["name"]
        age = request.form["age"]
        image = request.files["image"]

        filename = str(uuid.uuid4()) + ".jpg"

        s3.upload_fileobj(
            image,
            BUCKET_NAME,
            filename,
            ExtraArgs={
                "ACL": "public-read",
                "ContentType": "image/jpeg"
            }
        )

        image_url = (
            f"https://{BUCKET_NAME}.s3.amazonaws.com/{filename}"
        )

        student = {
            "name": name,
            "age": age,
            "image": image_url
        }

        collection.insert_one(student)

        return jsonify({
            "message": "Submit successful!"
        }), 200

    except Exception as e:

        return jsonify({
            "error": str(e)
        }), 500


# ----------------------------------
# Run App
# ----------------------------------

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )