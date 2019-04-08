## Installation d'un server DNS sur Ubuntu

#### !!! se fait tout seul avec Ubuntu server (à la fin cocher server DNS)

# Adresse IP de l'installation du bind9 dans exemple
10.42.0.83

#### Installation du package bind9:
Sur Debian/Ubuntu :
`sudo apt-get install bind9`

Sur Red Hat/cent OS/Fedora :
`yum install bind9`

#### Configurer le serveur DNS cache
Décommentez et modifié les lignes suivantes dans le fichier /etc/bind/named.conf.options.

`forwarders {`
  ` 8.8.8.8;`
  ` 8.8.4.4;`
`};`

Après le changement dans le fichier, redémarrez le serveur DNS.
`sudo service bind9 restart`

#### Tester le serveur DNS cache

tester les services DNS :
`dig ubuntu.com`
si on relance la même commande : plus rapide (query time) car garder en mémoire

#### Configurer le serveur DNS Primaire/Master
Ajouter la resolution Forward et Reverse vers bind9, modifiez /etc/bind9/named.conf.local. (ou suivant version/distribution: /etc/bind/named.conf.local) :

`zone "NOMDOMAIN.net" { `
    `type master; `
    `file "/etc/bind/db.NOMDOMAIN.net"; `
`}; `
`zone "0.42.10.in-addr.arpa" { `
    `type master; `
    `notify no; `
    `file "/etc/bind/db.10"; `
`};`


#### Mise en place de la Forward resolution pour le serveur DNS Primaire/Master

copiez /etc/bind/db.local dans /etc/bind/db.NOMDOMAIN.net :
`sudo cp /etc/bind/db.local /etc/bind/db.NOMDOMAIN.net`

modifiez le fichier /etc/bind/db.NOMDOMAIN.net et remplacez :
    1. ligne SOA : localhost. remplacez « localhost. » par « ns.NOMDOMAIN.net. »
    2. lignes SOA : root.localhost. remplace par lak.localhost.
    3. lignes NS : localhost. changez donc pour « ns.NOMDOMAIN.net. »
    
Une fois que les changements sont faits, le fichier /etc/bind/db.NOMDOMAIN.net ressemblera à sa :
`$TTL 604800 `
`@ IN SOA ns.NOMDOMAIN.net. lak.localhost. ( `
     `1024 ; Serial `
     `604800 ; Refresh `
     `86400 ; Retry `
     `2419200 ; Expire` 
     `604800 ) ; Negative Cache TTL` 
`;`
`@ IN NS ns.NOMDOMAIN.net. `
`NOMDOMAIN.net. IN MX 10 mail.NOMDOMAIN.net. `
`ns IN A 10.42.0.83` 
`web IN A 10.42.0.80` 
`mail IN A 10.42.0.70` 


#### Mise en place de la Reverse resolution pour le serveur DNS Primaire/Master
Copiez le fichier /etc/bind/db.127 dans /etc/bind/db.10.
`sudo cp /etc/bind/db.127 /etc/bind/db.10`

modifiez le fichier /etc/bind/db.10, échangez les mêmes options que dans le fichier /etc/bind/db.NOMDOMAIN.net.
`$TTL 604800 `
`@ IN SOA ns.supinfo.net. root.supinfo.net. ( `
     `20 ; Serial`  
     `604800 ; Refresh `
     `86400 ; Retry `
     `2419200 ; Expire `
     `604800 ) ; Negative Cache TTL `
`; `
`@ IN NS ns.` 
`83 IN PTR ns.supinfo.net.` 
`70 IN PTR mail.supinfo.net.` 
`80 IN PTR web.supinfo.net.`


Redémarrez le service bind9 :
`sudo service bind9 restart`

Verification de l'installation du server DNS : PING :) 










