# Installation Puppet agent sur ubuntu

rpm -ivh https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm

yum install puppet-agent -y


# Configuration de l'agent

$ vim /etc/puppetlabs/puppet/puppet.conf

[main]
certname = client.remy.org
server = master.remy.org
environment = production
runinterval = 1h

# Lancement Puppet et autorisation firewall

systemctl start puppet
systemctl enable puppet
firewall-cmd --add-port=8140/tcp --permanent
	# success
firewall-cmd --reload
	# success

# Signature d'un certificat

/opt/puppetlabs/bin/puppet agent -t