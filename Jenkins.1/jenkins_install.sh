#!/usr/bin/env bash
# This script install Jenkins in your Ubuntu System
# Install Java

sudo apt update
sudo apt install openjdk-8-jdk

#Add the Jenkins Debian repository.
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

#Next, add the Jenkins repository to the system with:
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

#Install Jenkins.
sudo apt update
sudo apt install jenkins

# lancement
systemctl start jenkins
#vérification : systemctl status jenkins

# Ajustement du Firewall
sudo ufw allow 8081

# vérification : sudo ufw status

# setting up jenkins on the interface on http://your_ip_or_domain:8081 
# print the password on the terminal commad: sudo cat /var/lib/jenkins/secrets/initialAdminPassword
# Copy the password from your terminal, paste it into the Administrator password field and click Continue
# then follow the interface

