# Réseau, interfaces, DNS, DHCP
### Index
[Diagnostic & Informations](#diag) <br />
[Activer une interface réseau](#ifup) - [Configurer une interface réseau](#ifcfg) <br />
[Système de Noms de Domaine *DNS*](#dns) - [Installer son propre serveur DNS](#dns_srv) <br />
[Protocole de Configuration Dynamique des Hôtes](#dhcp) - [Configuration de la passerelle](#gateway)

## <a name="diag" /> Diagnostic & Informations
Lister ses cartes et leur adresse **ip** avec `ip a` ou `ifconfig`

## <a name="ifup" />Activer une interface réseau
### One-shot
`ifup ens42` ou toutes `ifup -a`
### De façon permanente
Utiliser l'interface de `nmtui` pour modifier la connexion `ens42`

## <a name="ifcfg" />Configuration
### Configurer une interface réseau (CentOS)
Sous `/etc/sysconfig/network-scripts/`
```bash
vim ifcfg-ens42
```
```ini
TYPE=Ethernet
BOOTPROTO=static
BROADCAST=192.168.1.255
IPADDR=10.0.0.100
NETWORK=192.168.1.0
NAME=ens42
DEVICE=ens42
ONBOOT=yes
```
```bash
systemctl restart network
```
### Configurer une interface réseau (Debian)
Paramétrer l'accès de l'ordinateur à un réseau : `vim /etc/network/interfaces`
```sql
allow-hotplug ens42
iface ens42 inet static
address 192.168.0.2
netmask 255.255.255.0
gateway 192.168.0.1
```

### <a name="dns" />Système de Noms de Domaine *DNS*
Changer son Nom de Domaine Complètement Qualifié *FQDN* : `vim /etc/hostname`

Attribuer des noms d'hôte à des adresses **ip** : `vim /etc/hosts
`
```sql
127.0.1.1  morgane.ajc.org
10.0.0.200 morgane.ajc.org
```
### Spécifier son serveur DNS
#### CentOS :
Désactiver la gestion du DNS par NetworkManager :
```bash
vim /etc/NetworkManager/NetworkManager.conf
```
```ini
[main]
dns=none
```
```bash
systemctl restart NetworkManager
```

Renseigner le serveur de noms aux clients et au serveur lui-même :
```bash
vim /etc/resolv.conf
```
```sql
domain      morgane.ajc.org
search      morgane.ajc.org
nameserver  10.0.0.200
```
#### Debian :
```bash
apt install resolvconf
cd /etc/resolvconf/resolv.conf.d/
ls ; more *
vim base
```
```sql
domain      morgane.ajc.org
search      morgane.ajc.org
nameserver  10.0.0.200
```

### <a name="dns_srv" />Installer son propre serveur DNS `bind9` (*Berkeley Internet Naming Daemon*) :
```bash
apt install bind9 bindutils
```

```bash
vim /etc/bind/named.conf.local
```
```json
zone "ajc.org" {
        type master;
        file "/etc/bind/db.ajc.org";
};
zone "0.0.200.in-addr.arpa" {
        type master;
        file "/etc/bind/db.0.0.200.in-addr.arpa";
};
```

```bash
vim /etc/bind/db.ajc.org
```
```sql
$TTL 10800
$ORIGIN ajc.org.
@       IN SOA  morgane.ajc.org. root.ajc.org. (
                20160505;
                3h;
                1h;
                1w;
                1h);
@               IN NS   morgane.ajc.org.
morgane         IN A    10.0.0.200
clara           IN A    10.0.0.201
isabella        IN A    10.0.0.202
; ici se trouve la liste des noms connus du serveur de noms
```

```bash
vim /etc/bind/db.0.0.200.in-addr.arpa
```
```sql
$TTL 10800
$ORIGIN 0.0.200.in-addr.arpa.
@       IN SOA  morgane.ajc.org. root.ajc.org. (
                20160505;
                3h;
                1h;
                1w;
                1h);
@               IN NS   morgane.ajc.org.
10              IN PTR  morgane.ajc.org.
```
* IN internet
* SOA start-of authority
* NS name server
* A address
* CNAME canonical name
* MX mail server

```bash
systemctl restart bind9
dig clara.ajc.org
```

### <a name="dhcp" /> Protocole de Configuration Dynamique des Hôtes *DHCP*
```bash
apt install isc-dscp-server
vim /etc/dhcp/dhcpd.conf
systemctl restart isc-dhcp-server
vim /etc/network/interfaces
```
### <a name="gateway" /> Configuration de la passerelle/*gateway*
Voir `/etc/dhcp/dhcpd.conf`

