#!/usr/bin/env python
import torch
from flask import Flask, request, jsonify
import importlib

sd = importlib.import_module("docker-entrypoint")
app = Flask(__name__)
inProgress = False

@app.route("/status")
def check_status():
  return "test"

@app.route("/execute", methods=['POST'])
def execute():
  data = jsonify(request.json)
  
  token = ""
  with open("token.txt") as f:
    token = f.read().replace("\n", "")

  sd.stable_diffusion(
    data.prompt,          # prompt
    1,                    # samples
    1,                    # iters
    512,                  # height
    512,                  # width
    50,                   #ddim steps
    7.5,                  # scale
    torch.random.seed(),  # seed
    False,                # half
    False,                # skip
    False,                # do_slice
    token
  )

# /usr/local/bin/python3 /Users/dominicfung/Documents/stable-diffusion-docker/sd-service.py 
if __name__ == "__main__":
  app.run(port=8080)