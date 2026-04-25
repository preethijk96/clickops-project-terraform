from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import boto3
import os
import uuid

app = Flask(__name__)
CORS(app)

ENVIRONMENT = os.getenv("ENVIRONMENT","prd")
MONGO_HOST  = os.getenv("MONGO_HOST","mongodb-prd")
DB_NAME     = os.getenv("DB_NAME","clickops-prd")
BUCKET_NAME = os.getenv("S3_BUCKET","clickops-bucket-prd")
AWS_REGION  = os.getenv("AWS_REGION","ap-south-1")

client = MongoClient(f"mongodb://{MONGO_HOST}:27017/")
db = client[DB_NAME]
collection = db.users

s3 = boto3.client(
    "s3",
    region_name=AWS_REGION
)

@app.route("/")
def home():
    return jsonify({"status":"running"})

@app.route("/list")
def list_students():

    records=[]

    for doc in collection.find({},{"_id":0}):
        records.append(doc)

    return jsonify(records)


@app.route("/add",methods=["POST"])
def add_student():

    try:
        name=request.form["name"]
        age=request.form["age"]
        image=request.files["image"]

        filename=str(uuid.uuid4())+".jpg"

        # Upload image to S3
        s3.upload_fileobj(
            image,
            BUCKET_NAME,
            filename
        )

        image_url=f"https://{BUCKET_NAME}.s3.amazonaws.com/{filename}"

        # Save to MongoDB
        collection.insert_one({
            "name":name,
            "age":age,
            "image":image_url
        })

        return jsonify({
            "message":"Submit successful!"
        }),200


    except Exception as e:
        return jsonify({
            "error":str(e)
        }),500


if __name__=="__main__":
    app.run(host="0.0.0.0",port=5000)