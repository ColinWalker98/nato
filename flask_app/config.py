import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Config:
    DEBUG_MODE = os.getenv('DEBUG_MODE', True)
    MONGO_USER_NAME = os.getenv('MONGO_USER_NAME','wcol')
    MONGO_USER_PASSWORD = os.getenv('MONGO_USER_PASSWORD','wcol')
    MONGO_URI = os.getenv('MONGO_URI','localhost:27017')