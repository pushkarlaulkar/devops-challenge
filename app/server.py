# Import the main flask modules and other mandatory & preferred module
from flask import Flask, jsonify, request
from datetime import datetime

#Initializing the app
app = Flask(__name__)

#Default route
@app.route('/')
def index():
    response = {
        "Time" : datetime.utcnow().strftime('%d %b %Y %I:%M %p'),
        "Client IP" : request.remote_addr
    }
    return jsonify(response)

#Calling the app, debug option will make sure that app reloads everytime some code is changed
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)