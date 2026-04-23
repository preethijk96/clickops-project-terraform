from flask import Flask,request,jsonify
from flask_cors import CORS
from pymongo import MongoClient
import boto3,uuid

app=Flask(__name__)
CORS(app)

mongo=MongoClient("mongodb://mongodb:27017/")
db=mongo.clickops

bucket="clickops-bucket-dev"

s3=boto3.client(
"s3",
region_name="ap-south-1"
)

@app.route("/")
def home():
    return jsonify({"message":"Backend running"})

@app.route("/add",methods=["POST"])
def add():
    try:
        name=request.form["name"]
        age=request.form["age"]
        image=request.files["image"]

        filename=str(uuid.uuid4())+"-"+image.filename

        s3.upload_fileobj(
            image,
            bucket,
            filename
        )

        image_url=f"https://{bucket}.s3.amazonaws.com/{filename}"

        db.records.insert_one({
            "name":name,
            "age":age,
            "image":image_url
        })

        return jsonify({
         "message":"Saved in MongoDB and image uploaded to S3"
        })

    except Exception as e:
        return jsonify({"error":str(e)}),500


app.run(host="0.0.0.0",port=5000)