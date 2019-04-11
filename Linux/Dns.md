## •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
## •• Debian 9 •••••••••••••••••••••••••••••••••••••••• DNS ••
## •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

### ••••••••••••••••••••••• MISE A JOUR •••••••••••••••••••••••
```
apt update -y
apt install -y bind9 bind9utils dnsutils
```
### •••••••••••••••••••••••• HOSTNAME •••••••••••••••••••••••••
```
dns.ben.lan
```
### •••••••••••••••••••••••••• HOSTS ••••••••••••••••••••••••••
```
127.0.0.1	dns.ben.lan
10.0.0.254	dns.ben.lan
```
### •••••••••••••••••••• named.conf.local •••••••••••••••••••••
```
zone "ben.lan" {
        type master;
        file "/etc/bind/db.ben.lan";
};
zone "0.0.10.in-addr.arpa" {
        type master;
        file "/etc/bind/db.0.0.10.in-addr.arpa";
};
```
### ••••••••••••••••••••••• db.ben.lan ••••••••••••••••••••••••
```
$TTL 10800
$ORIGIN ben.lan.
@	IN SOA dns.ben.lan. root.ben.lan. (
		20190101;
		3h;
		1h;
		1w;
		1h;
)
@	IN NS	dns.ben.lan.
dns	IN A	10.0.0.254
srv	IN A	10.0.0.10
cli	IN A	10.0.0.20
```
### ••••••••••••••••• db.0.0.10.in-addr.arpa ••••••••••••••••••
```
$TTL 10800
$ORIGIN 0.0.1.in-addr.arpa.
@	IN SOA dns.ben.lan. root.ben.lan. (
		20190101;
		3h;
		1h;
		1w;
		1h;
)
@	IN NS 	dns.ben.lan.
10	IN PTR	dns.ben.lan.
```
## •• Centos 7 •••••••••••••••••••••••••••••••••••••••• SRV ••

### ••••••••••••••••••••••• MISE A JOUR •••••••••••••••••••••••
```
ONBOOT=no; dhclient; yum update -y
```
### •••••••••••••••••••••• INSTALLATION •••••••••••••••••••••••
```
yum install -y bind-utils
```
### •••••••••••••••••••••••• HOSTNAME •••••••••••••••••••••••••
```
srv.ben.lan
```
### •••••••••••••••••••••••••• HOSTS ••••••••••••••••••••••••••
```
127.0.0.1	srv.ben.lan
10.0.0.10	srv.ben.lan
```
### ••••••••••••••••••• NetworkManager.conf •••••••••••••••••••
```
[main]
dns=none
```
### ••••••••••••••••••••••••• RESOLV ••••••••••••••••••••••••••
```
domain ben.lan
Search ben.lan
nameserver 10.0.0.254

search local domain
nameserver 192.168.X.X
```
### •••••••••••••••••••••••• INTERFACE ••••••••••••••••••••••••
```
TYPE="Ethernet"
BOOTPROTO="static"
IPADDR=10.0.0.10
NETMASK=10.0.0.255
DEFROUTE="yes"
DEVICE="ens33"
DNS=10.0.0.254
ONBOOT="yes"
```
## •• Centos 7 •••••••••••••••••••••••••••••••••••••••• CLI ••


### ••••••••••••••••••••••• MISE A JOUR •••••••••••••••••••••••
```
ONBOOT=no; dhclient; yum update -y
```
### •••••••••••••••••••••• INSTALLATION •••••••••••••••••••••••
```
yum install -y bind-utils
```
### •••••••••••••••••••••••• HOSTNAME •••••••••••••••••••••••••
```
cli.ben.lan
```
### •••••••••••••••••••••••••• HOSTS ••••••••••••••••••••••••••
```
127.0.0.1	cli.ben.lan
10.0.0.10	cli.ben.lan
```
### ••••••••••••••••••• NetworkManager.conf •••••••••••••••••••
```
[main]
dns=none
```
### ••••••••••••••••••••••••• RESOLV ••••••••••••••••••••••••••
```
domain ben.lan
search ben.lan
nameserver 10.0.0.254

search localdomain
nameserver 192.168.X.X
```
### •••••••••••••••••••••••• INTERFACE ••••••••••••••••••••••••
```
TYPE="Ethernet"
BOOTPROTO="static"
IPADDR=10.0.0.20
NETWORK=10.0.0.0
BROADCAST=10.0.0.255
DEFROUTE="yes"
DEVICE="ens33"
DNS=10.0.0.254
ONBOOT="yes"
```