# Project Title

Définition d'un rôle pour la création d'un super-utilisateur dans le cadre de l'installation d'un serveur apache

## Getting Started

Création du dossier du rôle avec son arborescence de dossiers :
```
ansible-galaxy init nomdurole
```
`Dans le dossier racine`  du dossier du rôle:
- création d'un playbook "playbook".yml
- création ou modification d'un inventaire "inventaire".inv


## Installing

### Playbook

Défintion des hosts et variables :

```
- name: "Création d'un super utilisateur"
# envoie à toutes les machines du .inv
  hosts: inventaire
# remote_user définit l'utilisateur utilisé
  remote_user: root
# récupère les données des hosts
  gather_facts: yes
  roles: 
   - role: "sudoer"
```
### Inventaire

Création de groupe et désignation de machine :
```
[sudoer]
vps556644.ovh.net ansible_user=root
```

### Rôle

Dans le fichier vars/main.yml on indique les variables :
```
# on définit la variable du nom d'utilisateur
   user : "nomauchoix"
```


Dans le fichier tasks/main.yml on indique les opérations à lancer :
```
- name: "creation d'utilisateur"
  user:
   name: "{{ user }}"
# password created with:  python -c 'import crypt; print crypt.crypt("This is my Password", "$1$SomeSalt$")'
   password: "$1$SomeSalt$UtDNi9el2KVYtdK7LkIpX/"
   shell: "/usr/bin/bash"
- name: "Ajout de la clé SSH"
  authorized_key:
   user: "{{ user }}"
   key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
- name: "l'utilisateur devient un sudoer"
  lineinfile:
   dest: "/etc/sudoers"
   state: "present"
   line: "{{ user }} ALL=(ALL) NOPASSWD: ALL"
   validate: "visudo -cf %s"
```
### Commande de lancement

```
ansible-playbook -b -i "playbook".inv "inventaire".yml
```

    

