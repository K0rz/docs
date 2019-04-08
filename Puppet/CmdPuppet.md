# Puppet : http://puppetlabs.com/

## Définition :
La gestion de configuration consiste à gérer la description technique d’un système (et de ses divers composants), ainsi qu’à gérer l’ensemble des modifications apportées au cours de l’évolution du système.

## Avantages :
Factorisation des configurations (temps gagné/homogénéisation)
Passage à l’échelle
Traçabilité des modifications / Reporting
Formalisme au niveau de la configuration (voir DSL)
Partage et ré-utilisation (voir forge)
Une partie d’un PRA ? / Déploiement rapide (sécurité)

## Fonctionnement :
fonctionne mode client/serveur 
Puppet ne fonctionne pas en ssh mais avec CSR (certificat) : ensemble des communications effectuées sur SSL/TLS
installation puppet master et puppet agent 
le client demande au serveur sa configuration, qui à la réception de la requête, va compiler le catalogue
Puppet utilise le serveur HTTP WEBRick inclu dans Ruby (simple mais problèmes de perf)

### Module : 
un module = ensemble logique avec 3 principaux types de composants
Les modules sont une simple arborescence de fichiers et peuvent donc être gérées dans un SCM ou encore un système de stockage partagé

#### Manifests : extension .pp 
possibilité d'import `import` 
contiennent principalement les définitions d'une ou plusieurs classes
    les classes sont des collections de ressource décrivant un aspect de la configuration cible (fonctionnalités orientées objet : héritage,inclusion)
    une ressource = instance manipulable d'un type abstrait (Packager, service, users...) peut exprimer inter-dépendances temporelles entre les ressources
    providers = implémentations type abstraits `dpkg` ou `rpm` pour un package
    définitions = templates de ressources réutilisables 
    
Dans manifest on définit les noeuds : 
`node "ouich.vir-fai.net" {`
    `$dns_server = ’ns.vir-fai.net’`
    `include ’sharedadm’`
    `include ’nginxpack’`
`}`
utilisation serveur DNS (envoie identité) permet le fonctinnement SSL

`node "mirabelle.vir-fai.net" inherits "ouich.vir-fai.net" {`
    `$dns_server = ’ns2.vir-fai.net’`
    `include ’mediawiki’`
`}`

Compilation : construire le catalogue du noeud (ie arbre des dépendances avec les ressources associées)
La catalogue généré est alors donné au client, qui va être en charge d’exécuter les ordres de configuration à l’aide de facter (Application des ordres)
Facter est un outil intégré à Puppet pour récupérer un certain nombre de variables sur le système cible

facter :
`$ facter architecture => amd64 fqdn => node1.vir-fai.netn kernel => Linux kernelrelease => 3.10-3-amd64 lsbdistcodename => jessie lsbdistrelease => testing operatingsystem => Debian` [...]
Le client va alors appliquer les ordres de configuration paramètrés par facter sur son système
L’architecture de Puppet est relativement souple avec une flexibilité d’intégration intéressante pour son installation



    
### Fichiers : 

### Templates : 