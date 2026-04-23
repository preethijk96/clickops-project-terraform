from flask import Flask,request,jsonify
from flask_cors import CORS
from pymongo import MongoClient

app=Flask(__name__)
CORS(app)

mongo=MongoClient("mongodb://mongodb:27017/")
db=mongo.clickops

@app.route("/")
def home():
    return jsonify({"message":"Backend running"})

@app.route("/add",methods=["POST"])
def add():
    try:
        name=request.form["name"]
        age=request.form["age"]

        db.records.insert_one({
            "name":name,
            "age":age
        })

        return jsonify({
            "message":"Student saved successfully"
        })

    except Exception as e:
        return jsonify({"error":str(e)}),500

@app.route("/list")
def list_data():
    data=[]
    for x in db.records.find({},{"_id":0}):
        data.append(x)
    return jsonify(data)

app.run(host="0.0.0.0",port=5000)