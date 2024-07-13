from flask import jsonify, render_template
from app import app, db

@app.route('/')
def index():
    return render_template('index.html', title="Home")

@app.route('/data')
def get_data():
    customer_coll = db.customers
    customers = customer_coll.find()
    result = [{"name": item["name"], "value": item["value"]} for item in customers]
    return render_template('data.html', title="Data", data=result)