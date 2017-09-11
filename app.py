import os
import socket
from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/')
def hello():
  return jsonify(
    message = "Hello from pod %s running at node %s" %(socket.gethostname(), os.environ["NODE_NAME"])
  )

if __name__ == '__main__':
  app.run(
    host= "0.0.0.0",
    port = int("8080")
  )
