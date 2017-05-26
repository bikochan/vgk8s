#!/bin/sh
2>&1

/vagrant/ubuntu.sh

sudo kubeadm init --apiserver-advertise-address 172.16.0.10 | tee /vagrant/kubeadmin.out
grep "kubeadm join" /vagrant/kubeadmin.out > /vagrant/join.sh
chmod +x /vagrant/join.sh
sudo cp /etc/kubernetes/admin.conf /vagrant/

cat << EOT >> ~/.profile
export KUBECONFIG=/vagrant/admin.conf
source <(kubectl completion bash)
EOT

export KUBECONFIG=/vagrant/admin.conf
# patch kube-proxy config for vagrant
kubectl -n kube-system get ds kube-proxy -o json   | jq '.spec.template.spec.containers[0].command |= .+ ["--proxy-mode=userspace"]' |   kubectl apply -f -
kubectl -n kube-system delete pods -l k8s-app=kube-proxy
echo "Wating for kube-proxy to restart"
while true
do
  kubectl -n kube-system get pods -l k8s-app=kube-proxy | grep -q Running
  [ $? -eq 0 ] && break
  echo -n "."
  sleep 5
done

# install weave
kubectl apply -f https://git.io/weave-kube-1.6
echo "Wating for weave to start"
while true
do
  kubectl -n kube-system get pods -l name=weave-net | grep -q Running
  [ $? -eq 0 ] && break
  echo -n "."
  sleep 5
done

# install ddashboard
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
