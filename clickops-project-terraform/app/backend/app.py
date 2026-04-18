from flask import Flask, request, jsonify
import boto3, os, json
from pymongo import MongoClient

app = Flask(__name__)

region = "ap-south-1"

# AWS clients
s3 = boto3.client('s3', region_name=region)
sm = boto3.client('secretsmanager', region_name=region)

bucket = os.environ.get("BUCKET_NAME")
secret_name = os.environ.get("SECRET_NAME")

# Get secret
secret = sm.get_secret_value(SecretId=secret_name)
data = json.loads(secret['SecretString'])

mongo_host = data['host']
mongo_port = int(data['port'])

client = MongoClient(mongo_host, mongo_port)
db = client["clickops-db"]

@app.route("/")
def home():
    return "Backend Running 🚀"

@app.route("/add", methods=["POST"])
def add():
    name = request.form['name']
    age = request.form['age']
    file = request.files['image']

    s3.upload_fileobj(file, bucket, file.filename)

    db.employees.insert_one({
        "name": name,
        "age": age,
        "image": file.filename
    })

    return "Employee Added ✅"

@app.route("/list")
def list_data():
    data = list(db.employees.find({}, {"_id": 0}))
    return jsonify(data)

app.run(host="0.0.0.0", port=3000)