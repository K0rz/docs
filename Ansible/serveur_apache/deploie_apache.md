# adj3

## Deploiement d'un serveur apache sur une machine via ssh

### prerequis:
- on travaille sur une machine possedant ansible installé

- avoir une connexion ssh sur la machine distante
avoir genere une cle ssh
```
ssh-keygen
```
avoir copie sa cle sur la machine
```
ssh-copy-id root@vps123456.ovh.net
```

### Creation d'un fichier inventaire 
```
touch apache.inv
```
### renseignement du fichier inventaire
dans un premier temps, on se connecte avec l'utilisateur root.
exemple:
```
vps123456.ovh.net ansible_user=root
```

### on teste que la connexion marche bien avec un ping
```
ansible -i apache.inv -m ping all
```
### on definit un nom de machine apache
cela facilitera l'appel de la machine ulterieurement
```
sudo echo "12.34.56.78 serveur_apache" >> /etc/hosts
```

### on cree un playbook ansible
```
touch apache.yml
```
voir fichier apache.yml

### on execute le playbook
```
ansible-playbook -i apache.inv apache.yml
```