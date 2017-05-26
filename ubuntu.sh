#!/bin/sh
2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  jq

sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install docker-ce

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF > kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo mv kubernetes.list /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

ipaddr=$(ip addr show  enp0s8 | sed -e '/inet /!d;s/.*inet //;s,/.*,,')
sed -e "/$(hostname -s)/d" /etc/hosts > /tmp/hosts
echo "${ipaddr}   $(hostname -s)" >> /tmp/hosts
sudo mv /tmp/hosts /etc/hosts
