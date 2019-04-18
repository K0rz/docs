Démarrer firewall et Ouvrir port 80
=========

Prérequis
------------

ansibleuser doit être créé et doit avoir les droits sudoers.

Exemple Playbook
----------------

```
- name: "Start firewalld and Open port 80"
  hosts: server_apache
  remote_user: ansibleuser
  gather_facts: yes
  roles: 
   - role: "firewall"
```