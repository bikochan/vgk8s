# vgk8s

A pretty crude kubernetes cluster built for local dev.

Requirements:
* vagrant
* virtualbox w/ ubuntu xenial image

Not other dependencies.

Uses:
* kubeadm
* weave

to build a master and N (default 2) nodes.
Installs dashboard.

# Instructions

* Install [virtualbox](https://www.virtualbox.org/wiki/Downloads) and [vagrant](https://www.vagrantup.com/)
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

To access the dashboard:
```
kubectl --kubeconfig=admin.conf proxy &
open http://localhost:8001/ui
```

Tested on MacOSX only but should be fine on any Linux box too.

# Future (maybe)

Then again, this version fulfils its purpose
as I can quickly start a project, wipe and start over to the next.
Things I may improve someday:

* replace those shell scripts with Ansible eventually
* allow selection of network plugin
* multiple masters
* more customizations like preinstalling services
