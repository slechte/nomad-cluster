## Development Setup

This is a short description of my current development setup.
Normally, I develop under Linux. But if required, I will use a cygwin
environment under windows as well.

So my setup is like this:

* ~/ansible/roles : for the following roles
  * rattermeyer.docker
  * rattermeyer.nomad
  * rattermeyer.vault
* seperate checkout for `nomad-cluster`

The repositories are all available on my github repo:

`git clone git@github.com:rattermeyer/nomad-cluster.git`

roles have to cloned like the following

`git@github.com:rattermeyer/ansible-role-vault.git rattermeyer.vault`

The location of roles is defined inside `ansible/ansible.cfg`

You also need to create a `vault_pwd.txt` inside at `ansible/vault_pwd.txt` subdirectory.
For development, the current standard password is `nomad1`

After this, you shoud be able to start the VMs using `vagrant up`.

After powering up of VMs is finished, log in into the `controller` machine, using
`vagrant ssh controller`.

The `controller` is a seperate VM, because [Windows](http://docs.ansible.com/ansible/latest/intro_windows.html#windows-support)
is not supported as an ansible controller

After logging in change to `/vagrant/ansible` and run

`ansible-playbook -v -i inventories/test/inventory.ini site.yml`

That should do the magic and provision a nomad cluster consisting of

* 3 nomad servers and 2 worker nodes
* 3 consul servers
* 2 vault servers
* prometheus / grafana
* elasticsearch, mongodb replica set and graylog (TODO: not finished yet)
* traefik

### Servers

You can access the server with the following ip-adresses:

- server1: 192.168.56.21       
  - consul: https://192.168.56.21:8543   
  - vault-ui: http://192.168.56.21:8000      
  - node_exporter: http://192.168.56.21:9100/   
  - cadvisor: http://192.168.56.21:9110

- server2: 192.168.56.22       
  - consul: https://192.168.56.22:8543  
  - prometheus: http://192.168.56.22:9090/graph       
  - node_exporter: http://192.168.56.22:9100/   
  - cadvisor: http://192.168.56.22:9110
  
- server3: 192.168.56.23       
  - consul: https://192.168.56.23:8543  
  - grafana: http://192.168.56.23:3000       
  - node_exporter: http://192.168.56.23:9100/   
  - cadvisor: http://192.168.56.23:9110

- worker1: 192.168.56.24                                                  
  - node_exporter: http://192.168.56.24:9100/   
  - cadvisor: http://192.168.56.24:9110

- worker2: 192.168.56.25                                                  
  - node_exporter: http://192.168.56.25:9100/   
  - cadvisor: http://192.168.56.25:9110

- controller: 192.168.56.10

### Credentials
 
- grafana: admin:secret
 