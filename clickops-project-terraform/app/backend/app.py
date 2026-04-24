from flask import Flask,request,jsonify
from pymongo import MongoClient
from werkzeug.utils import secure_filename
import boto3
import os

app=Flask(__name__)

ENVIRONMENT=os.getenv("ENVIRONMENT","dev")

BUCKET_NAME=os.getenv(
"BUCKET_NAME",
f"clickops-bucket-{ENVIRONMENT}"
)

DB_NAME=os.getenv(
"DB_NAME",
f"clickops-{ENVIRONMENT}"
)

client=MongoClient(f"mongodb://mongodb-{ENVIRONMENT}:27017/")

db=client[DB_NAME]
collection=db.students


s3=boto3.client(
"s3",
region_name="ap-south-1",
aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY")
)


@app.route("/")
def home():
    data=list(
      collection.find({},{"_id":0})
    )
    return jsonify(data)



@app.route("/students")
def students():

    data=list(
      collection.find({},{"_id":0})
    )

    return jsonify(data)



@app.route("/add",methods=["POST"])
def add():

    try:

        name=request.form["name"]
        age=request.form["age"]

        file=request.files["image"]

        filename=secure_filename(
          file.filename
        )

        filepath="/tmp/"+filename

        file.save(filepath)

        s3.upload_file(
           filepath,
           BUCKET_NAME,
           filename
        )

        image_url=f"https://{BUCKET_NAME}.s3.ap-south-1.amazonaws.com/{filename}"

        student={
           "name":name,
           "age":age,
           "image":image_url,
           "environment":ENVIRONMENT
        }

        

    except Exception as e:

        return jsonify({
          "message":stresult = collection.insert_one(student)

student["_id"] = str(result.inserted_id)

return jsonify(student)r(e)
        }),500



app.run(
host="0.0.0.0",
port=5000
)