#Configuration Jenkins / GitLab

Source : https://medium.com/@teeks99/continuous-integration-with-jenkins-and-gitlab-fa770c62e88a

##Créer une clé SSH si pas déjà existant sur la machine où est installer Jenkins

Aller dans Credentials sous Jenkins
Ensuite System, Add Credentials

Dans la fenêtre de création indiquer :
kind : SSH username with private key
Scope : Global (Jenkins,...)
Username: mettre le nom du compte jenkins
Private key : copier votre clé (voir User\MY_USER\.ssh\id_rsa)

Puis valider (ok)

## access token
Dans GitLab aller dans les paramètres, puis jeton d'accès (à droite)
Ajouter un nouveau Credential sous Jenkins (cf précédent), copier l'access token dans la rubrique API token

## config plugin gitLab
Dans confiration /Jenkins
Pour GitLab URL n'indiquer que l'addresse du vps par example ne pas mettre le chemin qui va au projet
Ajouter le Credential créé précédemment
Puis test la connection

## Configuration de la Pipeline
Cocher GitProject, indiquer le chemin du projet (clone http du projet)
Sélection le gitLab configurer ci-dessus

Lier la Pipeline au fichier Jenkinsfile dans le GitLab.
Si le projet est privé, ajouter un clé avec le nom et mot de passe.

Dans Build Triggers :
Cocher Build when a change ... GitLab
Dans avancer générer un clé secret (à copier coller pour configurer un webbook dans le paramètrage du projet sur GitLab)

Attention ne pas oublier de valider/enregistrer les modifications/paramètrage sous Jenkins

## "Webbook" sur GitLab

Dans le projet, (à droite) aller dans paramètres puis intégrations
Indiquer l'URL du vps port/project/nomduprojet
Puis indiquer le secret token cf précédent.
Puis "Add webhook" et tester






