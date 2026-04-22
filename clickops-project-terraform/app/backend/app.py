from flask import Flask, request, jsonify
from flask_cors import CORS
import boto3, os, uuid
from pymongo import MongoClient
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)

# -------- ENV --------
AWS_REGION = os.getenv("AWS_REGION","ap-south-1")
S3_BUCKET  = os.getenv("S3_BUCKET")

MONGO_HOST = os.getenv("MONGO_HOST","mongodb")
MONGO_PORT = os.getenv("MONGO_PORT","27017")

# -------- Mongo --------
client = MongoClient(
    f"mongodb://{MONGO_HOST}:{MONGO_PORT}"
)

db=client.clickops
users=db.users

# -------- S3 ----------
s3=boto3.client("s3",region_name=AWS_REGION)


@app.route("/")
def home():
    return jsonify({"status":"running"})


@app.route("/add",methods=["POST"])
def add():

    name=request.form.get("name")
    age=request.form.get("age")

    if "image" not in request.files:
        return jsonify({"error":"No image"}),400

    file=request.files["image"]

    ext=file.filename.split(".")[-1]
    filename=f"{uuid.uuid4()}.{ext}"

    # upload to s3
    s3.upload_fileobj(
        file,
        S3_BUCKET,
        filename,
        ExtraArgs={"ACL":"public-read"}
    )

    image_url=f"https://{S3_BUCKET}.s3.amazonaws.com/{filename}"

    doc={
        "name":name,
        "age":age,
        "image":image_url
    }

    users.insert_one(doc)

    return jsonify({
        "message":"Image Submitted Successfully",
        "user":doc
    })


@app.route("/list")
def list_users():
    data=[]

    for x in users.find({},{"_id":0}):
        data.append(x)

    return jsonify(data)


if __name__=="__main__":
    app.run(host="0.0.0.0",port=3000)