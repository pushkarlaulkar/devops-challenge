from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def index():
    response = {
        "timestamp": datetime.utcnow().strftime('%d %b %Y %I:%M %p'),
        "ip": request.remote_addr
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)