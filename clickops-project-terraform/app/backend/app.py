from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import boto3
import time
import os

app = Flask(__name__)
CORS(app)

ENVIRONMENT = os.getenv("ENVIRONMENT")
BUCKET_NAME = os.getenv("BUCKET_NAME")
DB_NAME = os.getenv("DB_NAME")
MONGO_HOST = os.getenv("MONGO_HOST")

client = MongoClient(f"mongodb://{MONGO_HOST}:27017/")
db = client[DB_NAME]
collection = db["records"]

s3 = boto3.client("s3", region_name="ap-south-1")

@app.route("/")
def home():
    return jsonify({
        "environment": ENVIRONMENT,
        "bucket": BUCKET_NAME,
        "database": DB_NAME
    })

@app.route("/add", methods=["POST"])
def add_student():
    name = request.form["name"]
    age = request.form["age"]
    file = request.files["image"]

    filename = str(int(time.time())) + ".jpg"
    file.save("/tmp/" + filename)

    s3.upload_file(
        "/tmp/" + filename,
        BUCKET_NAME,
        filename
    )

    image_url = f"https://{BUCKET_NAME}.s3.ap-south-1.amazonaws.com/{filename}"

    student = {
        "name": name,
        "age": age,
        "image": image_url,
        "environment": ENVIRONMENT
    }

    collection.insert_one(student)

    return jsonify({
        "message":"Student added successfully",
        **student
    })

@app.route("/students")
def students():
    users=[]
    for x in collection.find({},{"_id":0}):
        users.append(x)
    return jsonify(users)

if __name__=="__main__":
    app.run(
      host="0.0.0.0",
      port=5000
    )