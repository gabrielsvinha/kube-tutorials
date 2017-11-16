#!/bin/bash

sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
sudo apt-get update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

sudo groupadd docker
sudo usermod -aG docker $USER
