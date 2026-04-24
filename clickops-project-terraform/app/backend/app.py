from flask import Flask,request,jsonify
from pymongo import MongoClient
import boto3
import os
from werkzeug.utils import secure_filename

app=Flask(__name__)

ENV=os.getenv("ENVIRONMENT","dev")
BUCKET=os.getenv("BUCKET_NAME",f"clickops-bucket-{ENV}")
DB_NAME=os.getenv("DB_NAME",f"clickops-{ENV}")

# Environment specific Mongo
mongo_hosts={
 "dev":"mongodb-dev",
 "qa":"mongodb-qa",
 "prd":"mongodb-prd"
}

client=MongoClient(
f"mongodb://{mongo_hosts[ENV]}:27017/"
)

db=client[DB_NAME]
collection=db.students

s3=boto3.client(
"s3",
region_name="ap-south-1"
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

        path="/tmp/"+filename

        file.save(path)

        # upload image to env bucket
        s3.upload_file(
            path,
            BUCKET,
            filename
        )

        image_url=f"https://{BUCKET}.s3.ap-south-1.amazonaws.com/{filename}"

        student={
          "name":name,
          "age":age,
          "image":image_url,
          "environment":ENV
        }

        collection.insert_one(student)

        return jsonify({
          "message":"Student saved successfully",
          "student":student
        })

    except Exception as e:
        return jsonify({
          "message":str(e)
        }),500


app.run(
host="0.0.0.0",
port=5000
)