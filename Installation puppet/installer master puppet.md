## Tous faire avec sudo utilisateur ## 

# Installation Puppet Master sur centos

$ rpm -ivh https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm

$ yum install puppetserver -y

# Configuration du master

$ vim /etc/puppetlabs/puppet/puppet.conf

[master]
dns_alt_names = puppet.puppetmaster.dns.remy.org

[main]
certname = master.remy.org
server = master.remy.org
environment = production
runinterval = 1h

# Lancement Puppet et autorisation firewall

systemctl start puppetserver
systemctl enable puppetserver
firewall-cmd --add-port=8140/tcp --permanent
	# success
firewall-cmd --reload
	# success

# Lister et signer les certificats

/opt/puppetlabs/bin/puppetserver ca list
/opt/puppetlabs/bin/puppetserver ca sign --all
