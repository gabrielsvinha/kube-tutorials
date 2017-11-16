#!/bin/bash

echo "----- Installing docker + dependencies"

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

echo "----- Installing kubeadm + kubelet + kubectl"

sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo su -c  'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update -y

apt-get install -y \
  kubelet

sudo sed -i 38,40d /var/lib/dpkg/info/kubelet.postinst

sudo apt-get install -y \
  kubernetes-cni \
  kubectl \
  kubeadm
