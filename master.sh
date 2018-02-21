#!/bin/sh
2>&1

/vagrant/ubuntu.sh

kubeadm init --apiserver-advertise-address 172.16.0.10 --pod-network-cidr=192.168.0.0/16 | tee /vagrant/kubeadmin.out
grep "kubeadm join" /vagrant/kubeadmin.out > /vagrant/join.sh
chmod +x /vagrant/join.sh
cp /etc/kubernetes/admin.conf /vagrant/

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

# install calico
curl -L https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml \
 -o /tmp/calico.yaml
kubectl apply -f /tmp/calico.yaml

# install heapster
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/standalone/heapster-controller.yaml

# install ddashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
