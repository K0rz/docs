#!/bin/bash
#must have generated ssh-keygen doing anything
#IP adress must be the same as inventory

echo ">>>>>>>> Installation des Pré-requis <<<<<<<<<"
sudo apt install -y sshpass
ssh-keygen -f "/home/doc/.ssh/known_hosts" -R "151.80.144.22" 
sshpass -p "1TlVnYMs" ssh-copy-id root@151.80.144.22
sshpass -p "1TlVnYMs" ssh -t root@151.80.144.22 'apt install python-minimal'
sshpass -p "1TlVnYMs" ssh -t root@151.80.144.22 'apt install apache2'
echo ">>>>>>>> Fin Pré-requis <<<<<<<<<"
echo ">>>>>>>> Création user <<<<<<<<<"
sshpass -p "1TlVnYMs" ssh -o StrictHostKeyChecking=no -t root@151.80.144.22 'adduser adj3' 
echo ">>>>>>>> Création sudoer <<<<<<<<<"
sshpass -p "1TlVnYMs" ssh -o StrictHostKeyChecking=no root@151.80.144.22 'usermod -aG sudo adj3'
ansible-playbook -i inventory.inv sudo.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
echo ">>>>>>>> Deploiement <<<<<<<<<" 
ssh-copy-id adj3@151.80.144.22  
ansible-playbook -i inventory.inv docker-install.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
#ansible-playbook -i inventory.inv docker-create-network.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
#ansible-playbook -i inventory.inv docker-build-image.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
#ansible-playbook -i inventory.inv docker-container.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' 
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'mkdir /home/adj3/.kube'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'echo "token" >> /home/adj3/.kube/adm_token.txt'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'echo "token" >> /home/adj3/.kube/token.txt'
ansible-playbook -i inventory.inv kubebook.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
echo ">>>>>>>> Creation et ajout config kubectl <<<<<<<<<" 
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo cp /etc/kubernetes/admin.conf /home/adj3/.kube/config'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo chown adj3 /home/adj3/.kube/config'
echo ">>>>>>>> Installation Jenkins <<<<<<<<<"
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo add-apt-repository ppa:webupd8team/java'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo apt install oracle-java8-installer'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 "wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -"
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'"
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo apt install jenkins'
echo ">>>>>>>> Start Jenkins <<<<<<<<<"
ansible-playbook -i inventory.inv port.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'service jenkins start'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'service jenkins status'
ssh -o StrictHostKeyChecking=no -t adj3@151.80.144.22 'sudo ufw allow 8081'
echo ">>>>>>>> Deployment SUCCES <<<<<<<<<"
