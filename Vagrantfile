# -*- mode: ruby -*-
# vi: set ft=ruby :

master=1
master_ip="172.16.0.10"
nodes=1
nodes_cidr="172.16.0.10"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "#{master_ip}"
    master.vm.provision "shell", path: "master.sh"
    master.vm.provider :virtualbox do |vb|
      vb.customize [ "modifyvm", :id, "--memory", "1024" ]
    end
  end

  (1..nodes).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "#{nodes_cidr}#{i}"
      node.vm.provision "shell", path: "node.sh"
      node.vm.provider :virtualbox do |vb|
        vb.customize [ "modifyvm", :id, "--memory", "1024" ]
      end
    end
  end

end
