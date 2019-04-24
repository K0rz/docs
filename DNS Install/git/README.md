#pour envoyer sur le github les modifications
- git pull pour être certain que tout est à jour
- git add [fichiers à ajouter]
	- le plus simple étant "git add ."
- git commit
- git push

#si vous voulez recharger les fichiers qui sont sur le github
- git fetch origin master
- git reset --hard FETCH_HEAD
- git clean -df
