from flask import Flask
from dotenv import load_dotenv
import os

# Load environment variables from .env file (provided by ansible.)
load_dotenv()

# Create Flask application
app = Flask(__name__)

# Load configuration variables from config.py
app.config.from_pyfile('config.py')

# Check if required configuration variables are present
required_variables = ['MONGO_URI', 'MONGO_USER_NAME', 'MONGO_USER_PASSWORD']
missing_variables = [var for var in required_variables if not app.config.get(var)]

if missing_variables:
    for var in missing_variables:
        print(f"Missing required configuration variable: {var}")
    exit(1)

# Define routes and other application logic here
@app.route('/')
def index():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(debug=app.config.get(debug_mode))
