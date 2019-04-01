DOCKER : Commandes

`ip -a` 
	IP du serveur 

Pour les images : site de docker « https://registry.hub.docker.com/ »

`sudo apt install docker` 
	installation docker sur machine (ici VPS … Virtual Server)

`sudo docker pull ubuntu`
	pull : récupère image 	ubuntu : nom de l’image 

`sudo docker images`
	liste les images présentes 

`sudo docker run -dit -p 1234:80 ID_images` 
	création d’in conteneur avec port :	1234:port du conteneur 	80 port de redirection 
	-t : attribue un terminal a notre nouveau container.
	-i : nous permet de faire une connexion interactive
	-d : permet à Docker d’exécuter container en arrière-plan
	-P : demande à Docker de cartographier tous les ports réseau

`sudo docker ps -a`
	liste des containers présents (ps : container, a : all) 
	docker ps –l 	Visualisé le dernier container exécuté
	docker ps –a 	 Visualisé tout les container créé
	docker ps  	Liste les conteneurs démarré

`sudo docker start ID_container`
	démarrer container 

`sudo docker attach ID_containers`
`sudo docker exec -it ID_containers /bin/bash`
	Accès sur un conteneur en exécution (2eme commande permet de ne pas le stopper en 	sortant)

DANS LE CONTAINER 
#======================
`apt update`
`apt upgrade`
	mise à jour du container 
`apt install apache2`
	installation apache2
`service apache2 status`
	verifie le statut d’un service (ici apache2)
`service apache2 start`
	Start le service 
`apt install ssh`
	installe service ssh 
`exit`
	sortie du container 
#=====================

	Vérification du bon fonctionnement du service du serveur apache2
	http://92.222.83.46:1234/ - 1234 le port du conteneur


`sudo docker commit ID_container apache/ssh`
	Créer une nouvelle image à partir du container (apache/ssh = nom de l’image créée)

`sudo docker run apache/ssh service apache2 start`
	déployer un container en intégrant une instruction – service apache2 start

`sudo docker run -dit -p 1234:80 -p 2200:22 ID_image`
	création de conteneur avec port 1234 :port du conteneur 80:redirection 2200:port du 	conteneur 22:redirection 

`sudo docker images` 
	vérifie création nouvelle image

`sudo docker inspect apache/ssh` 
	renseigner ports 80 et 22 dans le inspect

`sudo docker pull nginx` 
	Créer une image a partir d'internet avec nginx

`sudo docker inspect docker.io/nginx` 
	quel(s) port(s) doi(ven)t être renseigné(s), ici le port 80

`sudo docker run -dit -p 8080:80 ID_image` 
	Création de conteneur a partir de l'image avec nginx

	Vérification du bon fonctionnement de la page internet de nginx
	http://51.75.201.108:8080/ 

`sudo docker run -dit -p 8000:80 -p 2222:22 Id_image` 
	On créer un conteneur à partir de l'image qu’on a créée (Id_image peut aussi être remplacé 	par le nom attribué à l’image)

	Vérification du bon fonctionnement de la page internet
	http://51.75.201.108:8000/ -> marche pas (apache2 pas démarré)

`sudo docker run -d apache/ssh /usr/sbin/apache2ctl -D FOREGROUND`
	Créer un nouveau conteneur qui aura une commande en parametre "/usr/sbin/apache2ctl -D 	FOREGROUND" permettant de lancer automatiquement apache au démarrage 

`sudo docker commit ID_container apachestart/ssh` 
	Création nouvelle image qui lancera automatiquement le service apache

`sudo docker run -dit -p 8001:80 -p 2201:22 apachestart/ssh` 
	On créé un conteneur a partir de notre nouvelle image

	Vérification du bon fonctionnement de la page internet
	http://51.75.201.108:8001/ -> Le site fonctionne

`docker commit IP_container Nom_voulu`
	Créer une image à partir d’un container 
	Container ~ fils de l’image donc si image mise à jour container suit 

`docker run -dit -P apache/virtus /usr/sbin/apachectl -D FOREGROUND`
	Commande -P attribut automatiquement un port (IP adresse) 

`docker rm -f $(docker ps -a -q)`
	commande pour supprimer tous les containers (-f les containers, -a tous les containers)

`docker rm -i` 
	supprimer les images 
`docker volume create –name vol1`
	créer volume nommé vol1
`docker volume ls`
	liste des volumes créés
`df -h` 
	disque files (option h=human afficher en mode humain…)

`docker run -dit -v nom_volume:/var/www/html nom_image`
	créée un container avec :redirection du volume vers point de montage (ici /var/www/html) 
	plusieurs créations avec même volume : ne fonctionne pas (pas de partage du volume)

`docker volume inspect NOM_VOLUME`
	Vérification montage du volume 

`docker volume rm NOM_VOLUME`
	suppression du volume 
	(suppression des containers ne supprime pas les volumes)

`mkdir data` 
	création d’un répertoire pour partager à plusieurs containers 

`docker run -dit –name=HOST1 –hostname=HOST1 -v /home/Gomgom/data:/data apache/virtus` 
	créer container avec le repertoire crée précédemment

`docker exec -it host1 /bin/bash`
	rentrer dans le container pour executer 

`df -h`
	verification que le dossier est bien monté (dossier pointe vers extérieur)

	Données persistentes ! Seul problème = utilisation simultanée : CONFLIT (utilise 	programme à l’intérieur) 

`rm -rf data`
	suppression du dossier (r:recursif) 
	du coup dans container le dossier est vide et on ne peut pas écrire dessus 

`docker network ls`
	description des reseaux 

`ip a` 
	niveau Docker => ip du réseau interne (pour interconnecté les containers:peuvent se pinger 	via le bridge)

`docker network inspect bridge`
	inspecte tous les éléments du bridge (réseau interne des containers)

	Création espace travail et Dockerfile 
`mkdir projet` 

`vim Dockerfile` 
	création Dockerfile
#======================================
`FROM ubuntu`

`RUN apt update -y && apt upgrade -y`
`RUN apt install -y apache2`

`VOLUME /var/www/html`

`ADD index.html /var/www/html`

`EXPOSE 80`

`CMD [" /usr/sbin/apache2ctl", "-D", "FOREGROUND"]`
#======================================
	contenu du Dockerfile
	!!! les commentaires pas de # 
	From = à partir de l’image 
	RUN= commande à executer à la création de l’image
	VOLUME = créé volume de partage « exposé » : un seul argument (auto volume 			dynamique), à chaque création:un volume créée
	ADD=ajoute un fichier (ici index.html dans le fichier /var/www/html) !!!attention nécessite que l’index soit créée
	EXPOSE= définition du port 
	CMD = commande inscrite dans l’image

`docker build -t NOM CHEMIN_DOCKERFILE`
	lancement du script Dockerfile : créer une image 
	!!!!!!!!!!!!! Automatisation !!!!!!!!!!!!!!!!!! 

`docker run -dit -P --name=NOM --hostname=NOM  toto bash`
	Création du container à partir de l’image créée avec le Dockerfile

`sudo yum install docker-compose`
	installation docker-compose 

`vim docker-compose.yml`
	création d’un script Docker-compose pour automatiser la création de containers 

`docker-compose up`
	lancement du script docker-compose.yml