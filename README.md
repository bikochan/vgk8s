# vgk8s

A pretty crude kubernetes cluster built for local dev.
Uses:
* vagrant
* virtualbox w/ ubuntu xenial image
* kubeadm
* weave

Not other dependencies.

Builds a master and N (default 2) nodes.

# Instructions

* Install virtualbox and vagrant
* vagrant up
* wait...

You can then connect using the admin.conf file that was generated when the master started.
```
ex: kubectl --kubeconfig=admin.conf get nodes
NAME      STATUS    AGE
master    Ready     7m
node-1    Ready     4m
node-2    Ready     2m
```
Tested on MacOSX only but should be fine on any Linux box too.

# Future

* replace those shell scripts with Ansible eventually
* allow selection of network plugin
* multiple masters
* more customizations
