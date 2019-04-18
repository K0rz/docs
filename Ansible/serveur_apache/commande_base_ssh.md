# Commandes de base de ANSIBLE pour une connexion SSH

## <u>Introduction</u>
Ansible est une gestion d'infrastructure traditionnelle et automatisée en tant que code, sous le langage PYTHON.

Il se base sur un système de ``` connexion ssh ``` . 

Il fonctionne avec un système d'architecture par ``` modules ```.

----

## <u>Installation du package ANSIBLE :</u>
- <u>Sous RedHat :</u>

Il est nécessaire d'activer les sources EPEL (Extra Package Enterprise Linux) avant l'installation du package ANSIBLE:

```
yum install epel-release 
yum install ansible 
```

- <u>Sous Debian : </u>installation via pip-python dans le cas où le package que vous obtenez par votre système est trop ancien :

```
sudo apt install python-pip
sudo pip install ansible
```

- Pour connaître la version de ANSIBLE:

```
ansible --version
```

____
## <u>Clés :</u>
L'information est protégée par une ` clé publique `, nécessaire au décryptage.
Elle est divisée en 2 parties:
- Clé publique 
- Clé privée

### <u>Création de la clé: </u>
 
``` 
ssh-keygen 
```

Cette clé est créée et récupérable dans un emplacement précis:

```
$HOME /.ssh.id_rsa.pub
```

Elle peut être copiée de ce fichier.

### <u>Partage de la clé:</u>
Pour se connecter à une machine extérieure et non locale, il faut pousser la ``` clé publique ``` chez la cible :

``` 
ssh-copy-id IP /  (user@IP: pour un user précis)
```

`/!\ En cas de problème d'envoi de la clé: /!\`

```
ssh-keygen -f "/home/toto/.ssh/known_hosts" -R "nom_serveur"
```

- "-f" : pointe le fichier dans lequel on crée la clé
- "-R" : hostname

____
## <u>Inventaire: </u>
- Le fichier .inv permet de préciser la machine à laquelle on souhaite se connecter: 

```
inventaire.inv
```

- Dans lequel on précise le user par lequel on souhaite se connecter ainsi que son IP: 

```
IP_de_la_machine ansible_user=toto
```

- Il est possible de créer des groupes contenant plusieurs machines:

```
[Nom_du_groupe]
 ip_machine1 ansible_user=user_machine1
 ip_machine2 ansible_user=user_machine2
 ip_machine3 ansible_user=user_machine3
```

- On peut tester la connexion par un ping (droit du root à avoir):

```
ansible -i inventaire.inv -m ping all
```


___

### <u>Pour donner les droits de root à un utilisateur à distance : </u>

- On transforme l'utilisateur en superuser (droit de root), sans lui redemander le mot de passe à chaque fois:

``` 
ansible -i fic.inv -m lineinfile -a "path=/etc/sudoers line='toto ALL=(ALL:ALL) NOPASSWD:ALL'" --become-method=su --become --ask-become-pass all
```


- La commande " ansible_user_id" récupère l'identifiant du user auquel on se connecte:

```
ansible -i fic.inv -m setup -a 'filter=ansible_user_id' --become-user toto --become all
```

Il est possible d'automatiser cette manipulation directement dans le fichier YAML (voir le document ` deploie_apache.md `).

- Une fois connecté à toto, pour vérifier qu'il est superuser :

```
sudo -l
visudo -cf%
```

____
## <u>Autres commandes:</u>
- Liste des commandes et documentations:
```
ansible-doc -l
```

- Module de `débug`:

```
ansible -m debug -a var=groups localhost
```

- Ping de l'inventaire:

```
ansible -i fic.inv -m ping all
```

Pour chaque modification de l'inventaire, il est bien de refaire un ping.