## Ansible :

`ssh-keygen`
Création de clé publiques/privées (dans fichier par défaut sinon ajouter argument -i avec chemin de la clé)

#### New user avec droits superUser :


connection au VirtualServer (VPS) via ssh
`ssh USER@IP_VPS`

Création d'un user
`sudo adduser NOM_USER`

Attribution d'un mot de passe
`sudo passwd NOM_USER`

Modification du fichier sudoers pour donner droits
`sudo visudo`
	ajout :
ROOT ALL=(ALL) ALL
NOM_USER ALL=(ALL) ALL
  (tous les droits su)

Sur machine locale
Envoie clé publique
`ssh-copy-id NOM_USER@IP_VPS`
Connection sans password grâce clé 
`ssh NOM_USER@IP_VPS`

#### Création fichier inventaire :

Création répertoire travail 
`mkdir AnsibleTest`

Déplacement dans le répertoire
`cd AnsibleTest`

Création fichier inventaire (root ou user)
`echo "139.99.202.68 ansible_user=root" >inventaire.inv`
`echo "139.99.202.68 ansible_user=deploy" >inventaire.inv`


Vérifier communication (ping)
`ansible -i rec-apache.inv -m ping all`

Afficher information (setup utilise variable pour avoir une info)
`ansible -i NOM_INV.inv -m setup -a ’filter=ansible_user_id’ all`
`ansible -i rec-apache.inv -m setup all`

Modifier droit user en SU e, ligne commande
`ansible -i rec-apache.inv -m lineinfile -a "path=/etc/sudoers line=’deploy ALL=(ALL:ALL) NOPASSWD: ALL’" --become-method=su --become --ask-become-pass all`

savoir quel est l’utilisateur vérifie l’opération `ansible -i rec-apache.inv -m setup -a ‘filter=ansible_user_id’ --become all`

Lancer opération avec user apache 
`ansible -i rec-apache.inv -m setup -a ’filter=ansible_user_id’ --become-user deploy --become all`

Installer apache sur vps
`ansible -i rec-apache.inv -b -m yum -a name=httpd all`

Active et lance le service apache
`ansible -i rec-apache.inv -b -m service -a "name=httpd state=started enabled=yes" all`

Copie (avec securité)
`ansible -i rec-apache-1.inv -b -m copy -a "src=test.html owner=apache group=apache dest=/var/www/html" all`

Création fichier.yml (Playbook):
`vim install-apache.yml`
Contentant (attention à l'indentation dans yml)
- name: "Apache Installation"
  hosts: all
  tasks:
   - name: "Install apache package"
     yum:
      name: "httpd"
      state: "present"
   - name: "Start apache service"
     service:
      name: "httpd"
      state: "started"
      enabled: yes
   - name: "Copy test.html"
     copy:
      src: "test.html"
      dest: "/var/www/html"
      owner: "apache"
      group: "apache"



lancement playbook 
`ansible-playbook -b -i INVENTAIRE.inv PLAYBOOK.yml`
-b que si à l’intérieur il y a de l’installation (nécessite connection root)

Consulter liste inventaire 
`ansible -m debug -a var=groups localhost`




`ansible -e variable=valeur -e @fichier-variables.yml -m debug -a var=variable localhost`
créer des fichiers de variables (au format YAML) ou encore de passer à Ansible des variables à l’aide de l’option -e

`ansible -i inventaire-apache.inv -m template -a "src=NOM.html.j2 dest=$PWD/{{inventory_hostname}}.html" -c local all`
Lancement playbook

création fichier html : (nommé booba.html.j2) en Jinja 
<html>
<head>
<title>Machine {{inventory_hostname}}</title>
</head>
<body>
<p>Cette machine s’appelle {{inventory_hostname}}</p>
</body>
</html>

playbook sous le nom d’inventory.yml :
- name: "Generate html file for each host"
  hosts: all
  connection: local
  tasks:
   - name: "html file generation"
     template:
      src: "booba.html.j2"
      dest: "{{playbook_dir}}/{{inventory_hostname}}.html"

 cp rec-apache.inv ./Jinja/inventaire-apache.inv
	copier dernier inventaire en changeant son nom 

`ansible-playbook -i inventaire-apache.inv inventory.yml`
Lancement du playbook


Fichier html avec boucle :
<html>
<head>
<title>Machine {{inventory_hostname}}</title>
</head>
<body>
<p>Cette machine s’appelle
{{inventory_hostname}}</p>
<p>Ci-dessous la liste de ces adresses :</p>
<ul>
{% for ip in ansible_all_ipv4_addresses %}
<li>{{ip}}</li>
{% endfor %}
</ul>
</body>
</html>


`ansible-playbook -i inventaire-apache.inv inventory.yml`
Lancement du playbook (!!!pensez à vérifier les noms des sources)

`grep li *.html`
	Affichage des résultats (interfaces réseau)
	Problème : toujours la même adresse ip (celle d’ansible)
récupérer des informations sur les machines distantes avant de s’en servir en local ⇒  plugin de connexion !! (ssh ou local) ainsi que la délégation (option delegate_to).

Pour ça : modif du playbook inventory.yml
- name: "Generate html file for each host"
  hosts: all
  gather_facts : yes
  tasks:
   - name: "html file generation"
     template:
      src: "booba.html.j2"
      dest: "{{playbook_dir}}/{{inventory_hostname}}.html"
     connection : local

puis relancement des commandes 
`ansible-playbook -i inventaire-apache.inv inventory.yml`
Lancement du playbook (!!!pensez à vérifier les noms des sources)

`grep li *.html`
Affichage des résultats (interfaces réseau)


Nouveau playbook pour déléguer :
- name: "Generate html file for each host"
  hosts: all
  gather_facts: yes
  vars:
   host_inventory: "139.99.202.68"
   inventory_dir: "/var/www/html/inventory"
  tasks:
   - name: "Create template directory"
     file:
      path: "{{inventory_dir}}"
      owner: "apache"
      group: "apache"
      mode: "0755"
      state: "directory"
      delegate_to: "{{host_inventory}}"
   - name: "html file generation"
     template:
      src: "test2.html.j2"
      dest: "{{inventory_dir}}/{{inventory_hostname}}.html"
     delegate_to: "{{host_inventory}}"

`ansible-playbook -b -i inventaire_group.inv inventory.yml`0
relancer playbook (penser que les users doivent être enregistrés sur chaque machines avec 	les bons droits (sudoers avec NOPASSWD : ALL) et -b pour forcer)




Lister les tags pour un playbook
`ansible-playbook install-apache.yml --list-tags`
Les tags se définissent dans le playbook : 

- name: "Apache Installation"
  hosts: all
  tasks:
   - name: "Install apache package"
     yum:
      name: "httpd"
      state: "present"
     tags: "testtags"
   - name: "Start apache service"
     service:
      name: "httpd"
      state: "started"
      enabled: yes
   - name: "Copy test.html"
     copy:
      src: "test.html"
      dest: "/var/www/html"
      owner: "apache"
      group: "apache"



Selection ou exclusion des tags : 
`--tags LIST_TAGS` ou `--skip LIST_TAGS`

lancement playbook avec qu'un tag : 
`ansible-playbook -i iventaire.inv install.yml --tags restart`
Permet d'executer qu'une tâche précise ici tagger restart (ou alors de ne pas l'exécuter avec --skip)

`ansible-galaxy init NOM_ROLE`
génère un squelette complet de rôle (fichiers, repertoires)
un repertoire avec autant de repertoire qu'il y a de role et un playbook 

`ansible-playbook --user root --ask-pass -b -i wiki.inv install-all.yml`
cas d'un server réinitialisé : utilisation du root avec demande de mdp pour début 
(pensez à installer package `sudo apt install sshpass`)
