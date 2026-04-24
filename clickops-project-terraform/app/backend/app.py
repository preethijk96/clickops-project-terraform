from flask import Flask, request, jsonify
from pymongo import MongoClient
from werkzeug.utils import secure_filename
import boto3
import os

app = Flask(__name__)

# Environment
ENVIRONMENT = os.getenv("ENVIRONMENT","dev")
BUCKET_NAME = os.getenv(
    "BUCKET_NAME",
    f"clickops-bucket-{ENVIRONMENT}"
)
DB_NAME = os.getenv(
    "DB_NAME",
    f"clickops-{ENVIRONMENT}"
)

# Mongo per environment
mongo_hosts = {
    "dev":"mongodb-dev",
    "qa":"mongodb-qa",
    "prd":"mongodb-prd"
}

client = MongoClient(
f"mongodb://{mongo_hosts[ENVIRONMENT]}:27017/"
)

db = client[DB_NAME]
collection = db.students

# S3
s3 = boto3.client(
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


@app.route("/add", methods=["POST"])
def add_student():

    try:

        name=request.form["name"]
        age=request.form["age"]

        file=request.files["image"]

        filename=secure_filename(
            file.filename
        )

        filepath="/tmp/"+filename

        file.save(filepath)

        # upload to correct bucket
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