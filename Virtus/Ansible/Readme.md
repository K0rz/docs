CONTENTS OF THIS FILE
---------------------
   
 * Introduction
 * Requirements
 * Installation
 * Configuration
 * FAQ
 * Maintainers

INTRODUCTION
------------

In this readme, we will see how to automatically deploy docker and kubernetes with Ansible

REQUIREMENTS
------------

* -A fully operationnal computer with SSH
* -Ansible
* -A super coder

INSTALLATION
------------

- Now, we will take a closer look at the script. There are 4 parts:
* Installation of prerequisites
* Creation of a sudo user
* Deployment
* Configuration
- In order to perform a complete installation, we need to set-up our computer with sshpass. It's a software with pass a password as an argument for an ssh connection.
```sh
echo ">>>>>>>> Installation des Pré-requis <<<<<<<<<"
sudo apt install -y sshpass
ssh-keygen -f "/home/doc/.ssh/known_hosts" -R "151.80.144.22"
sshpass -p "PSR2evXV" ssh -t root@151.80.144.22 'apt install -y python-minimal'
echo ">>>>>>>> Fin Pré-requis <<<<<<<<<"
```
- Then we create a user. One option which is ongoing is:
```sh
ssh -t
```
- this option show the tty of the ssh client and interact with it. 
```sh
echo ">>>>>>>> Création user <<<<<<<<<"
sshpass -p "PSR2evXV" ssh -o StrictHostKeyChecking=no -t root@151.80.144.22 'adduser adj3' #we have full control on the passwd 
echo ">>>>>>>> Création sudoer <<<<<<<<<"
sshpass -p "PSR2evXV" ssh -o StrictHostKeyChecking=no root@151.80.144.22 'usermod -aG sudo adj3' #we add adj3 user to sudo group
ssh-copy-id root@151.80.144.22 
ansible-playbook -i inventory.inv sudo.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' #we give no passwd-requirement to sudo group
```
- Finally, we can deploy docker first then kubernetes. We use ansible playbook to deploy then.
```sh
echo ">>>>>>>> Deploiement <<<<<<<<<" 
ssh-copy-id adj3@151.80.144.22  
ansible-playbook -i inventory.inv docker-install.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' 
ansible-playbook -i inventory.inv kubebook.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
```

CONFIGURATION
-------------

- We have 3 more manipulations to achive our cluster. Kubernetes needs a config file to create pods.
```sh
echo ">>>>>>>> Creation et ajout config kubectl <<<<<<<<<" 
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'mkdir /home/adj3/.kube'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo cp /etc/kubernetes/admin.conf /home/adj3/.kube/config'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo chown adj3 /home/adj3/.kube/config'
```
* All you have to do is :
```sh
./deploy.sh
```

FAQ
---

Q: SSH says that plublic-key is already stored but it's corrupted.

A: Simply copy and paste this in your tty with the right IP:
```sh
ssh-keygen -f "/home/doc/.ssh/known_hosts" -R "YOUR IP"
```

Q: Ansible says it needs a password to continue

A: There are multiples facts that could cause this trouble. First of all, beware to look at /etc/sudoer that %sudo has correctly write with :
```sh
%sudo ALL=(ALL) NOPASSWD: ALL
```
it can also come from the ansible command. -K option allows the user to set his password, in our case, we don't want to have set it. -b option allows to run operations with become (does not imply password prompting)
```yaml
ansible-playbook -i inventory.inv docker-install.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
```

Q: Where i can find key for master kubernetes ?

A: 2 options, first generate one token : 
```sh
kubeadm token generate
```
seconde one :
in the /etc/kubernetes/pki

MAINTAINERS
-----------

* The Mighty ADJ3:
* - Joana
* - Daniel
* - Jean-Christophe
* - Jérome
* - Alexandre
* [Gitlab](http://vps635270.ovh.net/)