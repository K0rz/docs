#!/bin/bash
ansible-playbook -u pi -b --ask-pass -i inventory.inv playbook.yml
