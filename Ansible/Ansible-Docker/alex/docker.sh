#!/bin/bash

if [ $1 = -d ]
then
    ansible-playbook -i docker.inv create-docker-container.yml -b

elif [ $1 = -c ]
then
    ansible-playbook -i docker.inv container.yml -b

elif [ $1 = -r ]
then
    ansible-playbook -i docker.inv delete-docker-container.yml -b

elif [ $1 = -b ]
then
    ansible-playbook -i docker.inv build-image.yml -b

elif [ $1 = -h ]
then 
    less help.txt
fi