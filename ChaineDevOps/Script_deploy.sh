#!/bin/bash

echo "*********** Installation Pré-requis **********"
sudo apt install -y sshpass
ssh-keygen -f "/home/Gomgom/.ssh/known_hosts" -R "51.75.201.107"
sshpass -p "1TlVnYMs" ssh-copy-id root@51.75.201.107
sshpass -p "1TlVnYMs" ssh -t root@51.75.201.107 'apt install python-minimal"
