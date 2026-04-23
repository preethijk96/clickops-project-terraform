from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import boto3,time,os

app = Flask(__name__)
CORS(app)

# Mongo
client = MongoClient("mongodb://mongodb:27017/")
db = client["clickops"]
collection = db["records"]

# S3
s3 = boto3.client(
    "s3",
    region_name="ap-south-1"
)

BUCKET="clickops-bucket-dev"


@app.route("/")
def home():
    return jsonify({"message":"Backend running"})


@app.route("/add", methods=["POST"])
def add_student():

    name=request.form["name"]
    age=request.form["age"]

    file=request.files["image"]

    filename=str(int(time.time()))+".jpg"

    file.save("/tmp/"+filename)

    s3.upload_file(
        "/tmp/"+filename,
        BUCKET,
        filename
    )

    image_url=f"https://{BUCKET}.s3.ap-south-1.amazonaws.com/{filename}"

    record={
        "name":name,
        "age":age,
        "image":image_url
    }

    collection.insert_one(record)

    return jsonify({
        "message":"Student saved successfully",
        "student":record
    })


@app.route("/students")
def students():
    data=[]

    for x in collection.find({},{"_id":0}):
        data.append(x)

    return jsonify(data)


app.run(
host="0.0.0.0",
port=5000
)