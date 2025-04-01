from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def index():
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr).split(',')[0].strip()
    
    response = {
        "Time": datetime.utcnow().strftime('%d %b %Y %I:%M %p'),
        "Client IP": client_ip
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)