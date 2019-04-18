# Configuration d'un serveur DNS

## Introduction
Pour configurer le serveur se servira de ce [tutoriel](https://www.supinfo.com/articles/single/1709-mise-place-serveur-dns-avec-bind9).

_Pour avoir à la fois du réseau internet et un réseau local, on utilisera deux cartes réseau. On en mettra une en dhcp et une autre en ipfixe._

_On peut également appliquer cette méthode pour les autres machines du réseau_

## Configuration du hostname
choisir un hostname :
```
vim /etc/hostname
```
contenu:
```
ns1.domain.lan
```
Configurer les ip dans le fichier hosts
```
vim /etc/hosts
```
Modifier le fichier pour avoir ces lignes (on choisit une ip fixe)
```
127.0.1.1 ns1.domain.lan
192.168.0.100 ns1.domain.lan
```
On reboot la machine pour prendre en compte son nouveau nom
```
reboot
```
## Configuration des cartes réseaux

### Debian / Ubuntu

>```
>vim /etc/network/interfaces
>```
>On configure nos deux cartes :
>```
>allow-hotplug ens33
>iface ens33 inet dhcp
>
>allow-hotplug ens34
>iface ens34 int static
>address 192.168.0.100
>netmask 255.0.0.0
>dns-nameservers 192.168.0.100
>```
>/!\ Ne pas préciser la gateway pour éviter les conflits.

### Red Hat / Centos
>On configure la première carte en dhcp
>```
>vim /etc/sysconfig/network-scripts/ifcgf-ens33
>```
>Il devrait y avoir la ligne :
>```
>BOOTPROTO=dhcp
>```
>On configure la deuxième carte en static
>```
>vim /etc/sysconfig/network-scripts/ifcgf-ens34
>```
>Modifier la ligne :
>```
>BOOTPROTO=static
>```
>Ajouter les lignes :
>```
>IPADDR=192.168.0.100
>NETMASK=255.255.255.0
>DNS=192.168.0.100
>```
>/!\ Ne pas préciser la gateway pour éviter les conflits.

Ensuite on relance le réseau
```
# Debian /ubuntu
systemctl restart networking
# RedHat / Centos
systemctl restart network
```

## Configuration du DNS
```
vim /etc/resolv.conf
```
On doit le remplir comme suit :
```
domain domain.lan
search domain.lan
nameserver 192.168.0.100 #cette adresse doit se trouver avant d'autres potentielles autres adresses
```
Pour éviter que le système modifie ces paramètres :
### Debian / Ubuntu
>```
>apt install resolvconf
>vim /etc/resolvconf/resolv.conf.d/base
>```
>On remplit ce fichier comme précédemment
>```
>domain domain.lan
>search domain.lan
>nameserver 192.168.0.100
>```
### Red Hat / Centos
>```
>vim /etc/NetworkManager/NetworkManager.conf
>```
>Dans la partie "[main]" ajouter dns=none comme suit :
>```
>[main]
>dns=none
>```
