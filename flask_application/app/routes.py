from flask import jsonify, request
from app import app, mongo

@app.route('/')
def index():
    return "Welcome to the Flask app!"
