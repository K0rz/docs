GIT Cours-Commandes :

serveur de dépôt (comme svn) : le plus répandu actuellement 
Base de données gère comme google doc (plusieurs travaillent sur même fichier)

s’installe en ligne de commande (de base sans interface graphique) => GitLab après puis GitLabCI avant GitHub (plateforme collaborative)
	GitHub = public ouvert à tous 
	GitLab = privée (s’installe sur un server pour s’en faire une version perso et refuser les 	inscritpions
	⇒ travail en collaboration
3 étapes : validé (sauvegarde db), modifié (modifié mais pas sauvegarder), indexé (marqué pour être envoyé sur la db



git config --global user.name "Margaux Charra"
	Configurer nom utilisateur 

git config --global user.email "margaux.charra@gmail.com"
	Configurer email utilisateur 

git config –-list
	Verifier la list des configurations envoyées 

git config --global color.ui auto
	Pour les couleurs dans git 

mkdir projetGit
	création dossier de travail

cd projetGit
	définition de ce dossier comme répértoire courant 

git init
	initialisation du projet (Initialized empty Git repository in /home/Gomgom/projetGit/.git/)
	(git ne fonctionne que si document .git dansle même endroit : éxécute en fonction de ce 	point git, peut y en avoir autant que de dossier de travail)

git clone 
	récupéré dépôt existant (projet git mis sur serveur de dépôt) basé sur protocole ssh 
git clone https://github.com/virtus1er/ajc-jenkins.git
	créer répertoire (nom du projet : ajc-jenkins) 
cd ajc-jenkins 
	déplacement dans le dossier créée 
git log
	(dans dossier créée) garde mémoire activité : traçabilité complète !!!

Dans fichier du projet : 
git add NOMFICHIER
	indexé mon fichier : validé pour le commit
git status
	expose le status 
git commit -m ‘FIRST COMMIT’
	commit ce qui est dans git add (-m ‘NOM_COMMIT’) 

echo "Goooooooooooooo" >> fichierGom
	Modification du fichier inital (ajout ligne)

git diff
	Permet de voir les modifications avec le commit précédent 

git commit -a -m ‘commit avec -a’
	permet de commiter sans indexé (etape add inutile)

git rm NOM_FICHER 
	permet de supprimer fichier 

git mv SOURCE DESTINATION 
	déplacer un fichier en réindexant dans la base de données 
	sinon 3 commandes : 
		mv SOURCE DESTINATION
		git rm SOURCE
		git add DESTINATION    
git log 
	voir historique 
 git log --graph 
	fait apparaître notion de branches (definie l’arbre) 
git log --graph --oneline –all
	Historique meilleur visualisation de l’arbre (départ racine puis remonte les branches)

=> grâce à cette mémoire permet de créer un programme en temps réel des avancées des développeurs 

Peut revenir sur la dernière modification 
git commit --amend 
	modifier un commit en reprennant l’index du commit précédent 

git reset HEAD NOM_FICHIER 
	lorsque l’on a indexé trop de fichiers par rapport au plan initial 

git checkout FICHIER
	revenir au fichier au niveau du précédent checkout (version commitée)

git remote 
	visualiser les serveurs distants enregistrés 
	avec clones : dépôt distant ‘origin’

git remote add Gui https://github.com/Gui/Project01
	ajouter des dépôts distants 

git fetch NOMDUDEPOT
	récupérer données d’un dépôt distant 
git push DEPOTDISTANT nomdelabranche
git push origin master
	pour pusher sur dépôt

git remote rename gui AJCFormation 
	renommer référence 

git tag 
	lister des étiquettes 
git tag -l ‘v1,0,*’
	faire une recherche 

git tag -a v1.0.5 - ‘Maversion 1.0.5’
git show v1.0.5
	créer des étiquettes annotées et afficher le détail 

git push origin v1.0.5
	pousser les étiquettes après les avoir créées 
git push origin –tags
	pousser toutes les étiquettes créées localement 

git checkout -b v1.0.5
	naviguer à travers les versions 

Créer une branche signifie diverger de la ligne principale de développement et continuer
à travailler sans impacter cette ligne (branche = ligne d’évolution)
git branch testing
	créer une nouvelle branche nommée testing
git branch
	les branches du dépôt locale
git branch -d NOM_BRANCH 
	supprimer une branche 
git chekout NOM_BRANCHE 
	passer ç une branche données 

Une fois branche ok : 2 choix soit fusion (merge) soit rebaser (rebase) 
fusion garde historique rebase supprime tout 

git merge NOM_BRANCHE
	fusion des modifications d’une branche données dans la branche courante 
	!!!!! on ne merge pas la branche dans laquelle nous sommes !!! se fait du tronc principal


racine du projet : cat .gitignore 
fichiers inutiles (doivent être ignorés) 

git clone https://github.com/Gomgom1er/Projet-DevOp.git
	Nouveau clone avec nouveau dépôt 


sinon 
#=============================================================
git remote add origin https://github.com/Gomgom1er/Projet-DevOp.git
	Sinon ajout du point origin (parce que déjà fait un clone)
git pull 
	mise à jour (récupéré la version la plus récente dans le dépôt)

git push -u origin master
#=============================================================	


