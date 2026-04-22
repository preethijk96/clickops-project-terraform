from flask import Flask,request,jsonify
from flask_cors import CORS
from pymongo import MongoClient
import boto3

app=Flask(__name__)
CORS(app)

mongo=MongoClient("mongodb://mongodb:27017/")
db=mongo.students

bucket="clickops-bucket-dev"

s3=boto3.client(
"s3",
region_name="ap-south-1"
)

@app.route("/")
def home():
    return "Backend running"

@app.route("/add",methods=["POST"])
def add():

    name=request.form["name"]
    age=request.form["age"]
    file=request.files["image"]

    filename=file.filename

    s3.upload_fileobj(
      file,
      bucket,
      filename
    )

    url=f"https://{bucket}.s3.amazonaws.com/{filename}"

    db.records.insert_one({
      "name":name,
      "age":age,
      "image":url
    })

    return jsonify({
      "message":"Student saved successfully"
    })


@app.route("/list")
def list_data():

    users=[]

    for x in db.records.find({},{"_id":0}):
        users.append(x)

    return jsonify(users)


app.run(
 host="0.0.0.0",
 port=3000
)