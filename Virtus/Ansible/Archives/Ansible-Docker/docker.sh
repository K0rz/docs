#!/bin/bash

if [ $1 = -i ] || [ $1 = -a ]
then
    ansible-playbook -i server_apache.inv install-docker.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
fi

if [ $1 = -n ] || [ $1 = -a ]
then
    ansible-playbook -i server_apache.inv create-docker-network.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
fi

if [ $1 = -b ] || [ $1 = -a ]
then
    ansible-playbook -i server_apache.inv build-image.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
if

if [ $1 = -c ] || [ $1 = -a ]
then
    ansible-playbook -i docker.inv container.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
fi

if [ $1 = -r ]
then
    ansible-playbook -i docker.inv delete-docker-container.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
fi

if [ $1 = -h ]
then 
    less help.txt
fi