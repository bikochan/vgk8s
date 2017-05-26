#!/bin/sh
2>&1

/vagrant/ubuntu.sh

cat << EOT >> ~/.profile
export KUBECONFIG=/vagrant/admin.conf
source <(kubectl completion bash)
EOT

source ~/.profile

sudo /vagrant/join.sh

