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

# Environment driven values
ENV=os.getenv("ENVIRONMENT","dev")
BUCKET=os.getenv("BUCKET_NAME",f"clickops-bucket-{ENV}")

# S3
s3=boto3.client(
    "s3",
    region_name="ap-south-1"
)

@app.route("/")
def home():
    return jsonify({
      "message":"Backend running",
      "environment":ENV
    })


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

    result=collection.insert_one(record)

    return jsonify({
       "message":"Student saved successfully",
       "id":str(result.inserted_id)
    })


@app.route("/students")
def students():

    data=[]

    for x in collection.find():
        x["_id"]=str(x["_id"])
        data.append(x)

    return jsonify(data)


app.run(
 host="0.0.0.0",
 port=5000
)