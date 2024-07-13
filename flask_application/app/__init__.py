from flask import Flask
from flask_pymongo import PyMongo

app = Flask(__name__)

# Configuration for MongoDB
app.config["MONGO_URI"] = "mongodb://localhost:27017/placeholder"
mongo = PyMongo(app)

from app import routes
