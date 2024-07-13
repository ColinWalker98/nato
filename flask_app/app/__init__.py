from flask import Flask
from pymongo import MongoClient
from config import Config

app = Flask(__name__)
app.config.from_object(Config)

# Initialize MongoDB client
client = MongoClient(app.config['MONGO_URI'])
db = client.web


from app import routes
