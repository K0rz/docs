#!/bin/bash
#must have generated ssh-keygen doing anything
#IP adress must be the same as inventory

ssh-copy-id yolo@vps649194.ovh.net && \
ansible-playbook -i inventory_sudo.inv change-root-password.yml -b --ssh-common-args='-o StrictHostKeyChecking=no' && \
ansible-playbook -i inventory_sudo.inv playbook_sudo.yml -b --ssh-common-args='-o StrictHostKeyChecking=no'
