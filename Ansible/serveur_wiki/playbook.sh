#!/bin/bash
#must have generated ssh-keygen doing anything
#IP adress must be the same as inventory
ssh-copy-id root@server_apache && \
ansible-playbook -i inventory_sudo.inv change-root-password.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' && \
ansible-playbook -i inventory_sudo.inv playbook_sudo.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' && \
ansible-playbook -i wiki.inv install-apache.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' && \
ansible-playbook -i wiki.inv playbook_firewall.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' && \
ansible-playbook -i wiki.inv install-mediawiki.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'  
