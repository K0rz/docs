# git

# Creer un depot git:
$ git init (dans le dossier souhaite)

# Cloner un depot:
$ git clone http(s)://_ _ _(IP)/projet.git

# Suivre un fichier
$ git add nom du fichier ou du repertoire
$ git add . (tous les fichiers et repertoires)

# Etat de suivi des fichiers
$ git status

# Ignorer des fichiers
liste des fichiers dans un fichier.gitignore 
 nom.gitignore
si le patron se termine par (/), c'est un repertoire

# Comparaison de version de fichier
$ git diff
$ git diff --cached (voir modifications de la prochaine validation)

# Valider les nouvelles modifications
$ git commit (affiche un fichier sans argument)
$ git commit -v (pour voir les differences dans le commentaire)
$ git commit -m 'commentaire'
$ git commit -a (ajoute tous les fichiers suivis dans l'index)

# Pour modifier un commit apres oublit de fichier
$ git add nom du fichier oublie
$ git commit --ammend (reprend index du commit precedent)

# Retirer un fichier deja indexe
$ git reset HEAD nom du fichier

# Faire revenir un fichier au niveau precedent
$ git checkout-fichier (attention perte des modifications)

### Attention ###
# Les fichiers suivis dans l'index doivent etre supprime ou deplacer par git

# suppression
$ git rm nomdufichier
$ git rm -rf nomdufichier (pour forcer)

# deplacer 
$ git mv soruce destination

# Historique
$ git log

# Recuperer des donnes d'un depot distant
$ git fetch nom du depot

# Pour envoyer et partager
$ git push
### Attention a ne pas travaiiler sur un meme fichier ###

# Lister les etiquettes
$ git tag
# Creer des etiquettes
$ git tag -a v(numero version 1.0.5) -m 'commentaire'

### Attention ### les etiquettes ne sont pas envoyees et partagees

# Pour envoyer et partager les etiquettes
$ git push origin --tags

# Naviguer a travers les versions
$ git checkout -b v(nom version 1.0.5)

Les Branches
### Il faut creer un fichier suivi (add) et modifier (commit) pour initier une branche master

# Pour savoir ou on se situe
$ git branche

# Creer branche
$ git branh nom de la branche

# Basculer dans la branche
$ git checkout nom de la branche
$ git checkout -b nom de la branche (pour la creer et se pacer dessus)

# Visualiser l'arbre
$ git log --online --decorate --graph --all
$ gitk --all
