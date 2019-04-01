Ansible :

Infrastructure en tant que code (2 outils Ansible et Puppet) 
playbook (yaml) pour déployer 
host (inventaire liste) 

Protocole ssh : avec clé publique/clé privée   = connexion assymétrique 

ssh-keygen 
	génére des clés publiques/privées (dans fichier par défaut sinon après doit ajouter 
	argument -i avec chemin de la clé)

(créer sur VPS un nouvel user deploy avec droits superUser) :
ssh USER@IP_VPS
	connexion au VPS
sudo adduser NOM_USER
	création user 
sudo passwd NOM_USER
	attribution mot de passe user 
sudo visudo 
	ajout après ligne ROOT ALL=(ALL) ALL de NOM_USER ALL=(ALL) ALL (tous les 	droits su) 

Sur machine locale 
ssh-copy-id NOM_USER@IP_VPS
	envoie clé publique à ce nouvel user 
ssh NOM_USER@IP_VPS
	Connection au VPS avec le nouvel user sans précision de mot de passe 


Création fichier inventaire rec-apache.inv
mkdir AnsibleTest
	création répertoire de test pour ansible 
cd AnsibleTest
	définition comme répertoire courant 
echo "139.99.202.68 ansible_user=root" >rec-apache.inv
echo "139.99.202.68 ansible_user=deploy" >rec-apache.inv
	création du fichier avec la ligne d’inventaire (soit avec nouvel user soit avec root)

ansible -i rec-apache.inv -m ping all
	vérifier que ça ping (bonne communication)

ansible -i NOM_INV.inv -m setup -a ’filter=ansible_user_id’ all
ansible -i rec-apache.inv -m setup all
	setup permet d’utiliser une variable pour avoir une information (ici que afficher)



ansible -i rec-apache.inv -m lineinfile -a "path=/etc/sudoers line=’deploy ALL=(ALL:ALL) NOPASSWD: ALL’" --become-method=su --become --ask-become-pass all
	methode pour que user passe avec droits superuser sans password(changement du dossier 	/etc/sudoers)

ansible -i rec-apache.inv -m setup -a ‘filter=ansible_user_id’ --become all
	permet de savoir quel est l’utilisateur avec lequel vous travaillez, vérifie que l’opération 	s’est bien passée 

ansible -i rec-apache.inv -m setup -a ’filter=ansible_user_id’ --become-user deploy --become all
	lancer les opérations avec l’utilisateur apache à la place de root

ansible -i rec-apache.inv -b -m yum -a name=httpd all
	permet d’installer apache sur vps 

ansible -i rec-apache.inv -b -m service -a "name=httpd state=started enabled=yes" all
	active et lance le service apache
ansible -i rec-apache-1.inv -b -m copy -a "src=test.html owner=apache group=apache dest=/var/www/html" all
	copie (avec securité)



Playbook = fichier YAML, donne une liste d’instructions passées à Ansible dans l’ordre de leur déclaration (tout décrit dans un fichier, y compris l’enchaînement des opérations)

fichier install-apache.yml contenant : vim install-apache.yml
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
!!!!!!! attention à l’indentation dans un yaml !!!!!!!!


ansible-playbook -b -i rec-apache.inv install-apache.yml
	lance le playbook 
	-b que si à l’intérieur il y a de l’installation (nécessite connection root) 

ansible -m debug -a var=groups localhost
	consulter liste inventaire 

ansible -e variable=valeur -e @fichier-variables.yml -m debug -a var=variable localhost
	créer des fichiers de variables (au format YAML) ou encore de passer
	à Ansible des variables à l’aide de l’option -e

ansible -i inventaire-apache.inv -m template -a "src=NOM.html.j2 dest=$PWD/{{inventory_hostname}}.html" -c local all
	lancement playbook 

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
!!!! yml : indentation
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

ansible-playbook -i inventaire-apache.inv inventory.yml
	lancement du playbook



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


ansible-playbook -i inventaire-apache.inv inventory.yml
	relancement du playbook (!!!pensez à vérifier les noms des sources)

grep li *.html
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
ansible-playbook -i inventaire-apache.inv inventory.yml
	relancement du playbook (!!!pensez à vérifier les noms des sources)

grep li *.html
	Affichage des résultats (interfaces réseau)
	Et là OKKKKKKKK 



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

ansible-playbook -b -i inventaire_group.inv inventory.yml
	relancer playbook (penser que les users doivent être enregistrés sur chaque machines avec 	les bons droits (sudoers avec NOPASSWD : ALL) et -b pour forcer)
