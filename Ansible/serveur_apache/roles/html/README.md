Role html
=========

Permet l'installation et le remplissage des infos machine via des template html.j2

Requirements
------------

-Serveur apache monté et prêt à recevoir les fichiers

Role Variables
--------------
Deux Choses à faire :
-Faire son propre playbook en reprennant l'exemple ci dessous
-faire son INVENTAIRE :
	Dans inv_USER.inv : Ajouter vos noms de domaine et/ou adresse IP de vos machines dans le groupe [machines]
	Enregistrez le avec le nom d'inventaire de votre choix. 


Example Playbook
----------------
Playbook Deploy-html.yml :
```
	- name: "Generate html file for each host"
  	  hosts: all
  	  gather_facts: yes
	  vars: 
       USER: "user a modif"
  	  roles: 
   	   - role: "html"
```

Author Information
------------------

Nous sommes plus qu'un nom, nous sommes légions
