## Development Setup

This is a short description of my current development setup.
Normally, I develop under Linux. But if required, I will use a cygwin
environment under windows as well.

### Requirements

The following tools have to be installed. We are using older versions of Vagrant and VirtualBox, because the newest versions didn’t work properly on Windows 7.
On Windows 10 the current versions VirtualBox 5.2 and Vagrant 2.0.1 are working correctly. Powershell 5 is already installed on Windows 10. 
On Windows 7 we experienced the following bug: https://github.com/hashicorp/vagrant/issues/9146
* Vagrant 1.9.8
 * https://www.vagrantup.com/downloads.html
* VirtualBox 5.1
 *	https://www.virtualbox.org/wiki/Downloads
*	Powershell 5
 * Use the following command in Powershell to indicate the installed version "$PSVersionTable.PSVersion"
 * Download Version 5: https://www.microsoft.com/en-us/download/details.aspx?id=50395


### Manual
#### 1.	Preperation
Create a folder for all files. Create the following subfolder in it:
*	roles: All ansible roles will be stored here

Check-out the following repository in the main folder. The files should end up in the folder “nomad-cluster”: https://github.com/rattermeyer/nomad-cluster
The following repositories should be checked-out in the roles folder and renamed accordingly:
https://github.com/rattermeyer/ansible-role-vault -> rattermeyer.vault
https://github.com/rattermeyer/ansible-role-consul -> rattermeyer.consul
https://github.com/rattermeyer/ansible-role-nomad -> rattermeyer.nomad


#### 2.	Adjustments
Under Windows you have to adjust the path for the shared folder of the roles in the Vagrantfile in the folder “nomad-cluster”.
Therefore you have to replace the first parameter with the complete path to the folder “roles”, which you have created in step 1
Important: Here you have to use slashes (/) instead of backslashes (\)
In the files “ansible.cfg” in the “ansible” subfolder there is a path to the vault password file. You have to add it and put the value “nomad1” inside.
Under Windows: the file should be created on the linux server, because otherwise it can’t be read correctly


#### 3.	Create the virtual devices
Open a terminal in the folder “nomad-cluster” and execute “vagrant up”
After the script has been executed, there should have appeared six VMs in VirtualBox


#### 4. Run the ansible playbook
Log into the controller machine using "vagrant ssh controller".
Change to /vagrant/ansible and run: ansible-playbook -v -i inventories/test/inventory.ini site.yml 
That should do the magic and provision a nomad cluster consisting of
* 3 nomad servers and 2 worker nodes
* 3 consul servers
* 2 vault servers
* prometheus / grafana
* elasticsearch, mongodb replica set and graylog (TODO: not finished yet)
* traefik


### Problems
#### shared folders not mount properly
When starting the VMs in VirtualBox all shared-folders are mounted under /media/_sf
and can not be found by the scripts, which use other paths.
It is recommended to start the VMs with Vagrant or mount the folders manually:

    sudo mount -t vboxsf -o rw,dmask=077,fmask=177,uid=vagrant,gid=vagrant vagrant /vagrant
    sudo mount -t vboxsf -o rw,uid=vagrant,gid=vagrant etc_ansible_roles /etc/ansible/roles
   
Here I used vagrant and etc_ansible_roles as the names for the synced folders in virtual box.
But these can be renamed in VirtualBox.
To mount the folders automatically at boot you can add the commands to /etc/rc.local or create an entry in /etc/fstab


### Servers

You can access the server with the following ip-addresses:

- server1: 192.168.56.21       
  - consul: https://192.168.56.21:8543   
  - vault-ui: http://192.168.56.21:8000      
  - node_exporter: http://192.168.56.21:9100/   
  - cadvisor: http://192.168.56.21:9110
  - nomad-ui: http://192.168.56.21:3000
  - nexus: http://192.168.56.21:8081

- server2: 192.168.56.22       
  - consul: https://192.168.56.22:8543  
  - prometheus: http://192.168.56.22:9090/graph       
  - node_exporter: http://192.168.56.22:9100/   
  - cadvisor: http://192.168.56.22:9110
  - nginx: http://192.168.56.22:80
  
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
- vault-ui: Use token authentification. You can use the root_token in /etc/vault/keys.json on the controller server.
- nexus: admin:admin123 
