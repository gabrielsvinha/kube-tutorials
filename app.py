import socket
from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/')
def hello():
  return jsonify(
    message = "Hello from %s" %socket.gethostbyname(socket.gethostname())
  )

if __name__ == '__main__':
  app.run(
    host = '0.0.0.0',
    port = int("8080")
  )
