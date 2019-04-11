# Puppet
### Index
[Installation](#install) - [Configuration](#conf) - [Signature d'un certificat](#cert) <br />
[Installation de Tomcat sur un nœud agent](#tomcat) <br />
[Installation de Wordpress sur un nœud agent](#wp)

Source: [howtoforge.com/tutorial/centos-puppet-master-and-agent/](https://www.howtoforge.com/tutorial/centos-puppet-master-and-agent/)
## <a name="install"> Installation
### Master (master.puppet CentOS)
```bash
rpm -ivh https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm
yum install puppetserver -y
```
### Marionnette (one.puppet CentOS)
```bash
rpm -ivh https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm
yum install puppet-agent -y
```

## <a name="conf"> Configuration
### Master (master.puppet CentOS)
```bash
vim /etc/puppetlabs/puppet/puppet.conf
```
```ini
[master]
dns_alt_names=master.puppet

[main]
certname = master.puppet
server = master.puppet
environment = production
runinterval = 1h
```
```bash
systemctl start puppetserver
systemctl enable puppetserver
firewall-cmd --add-port=8140/tcp --permanent
firewall-cmd --reload
```
### Marionnette (one.puppet CentOS)
```bash
vim /etc/puppetlabs/puppet/puppet.conf
```
```ini
[main]
certname = one.puppet
server = master.puppet
environment = production
runinterval = 1h
```
## <a name="cert"> Signature d'un certificat
### Marionnette (one.puppet CentOS)
```bash
/opt/puppetlabs/bin/puppet agent -t
```
### Master (master.puppet CentOS)
```bash
/opt/puppetlabs/bin/puppetserver ca list
/opt/puppetlabs/bin/puppetserver ca sign --all
```
### Marionnette (one.puppet CentOS)
```bash
/opt/puppetlabs/bin/puppet agent -t
```

## <a name="tomcat"> Installation de Tomcat sur un nœud agent
### Master (master.puppet CentOS)
```bash
puppet module install puppetlabs-tomcat --version 2.5.0
puppet module install puppetlabs-java --version 3.3.0
cd /etc/puppetlabs/code/environments/production/manifests
vim site.pp
```
```
node 'one.puppet' {
  include mytomcat
}
```
```bash
vim mytomcat.pp
```
```
class mytomcat {
        tomcat::install { '/opt/tomcat':
                source_url => 'https://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.92/bin/apache-tomcat-7.0.92.tar.gz',
        }
        tomcat::instance { 'default':
                catalina_home => '/opt/tomcat',
        }
}

```
### Marionnette (one.puppet CentOS)
```bash
/opt/puppetlabs/puppet/bin/puppet agent -t
```

## <a name="wp"> Installation de Wordpress sur un nœud agent
Source: [cloudifyblog.wordpress.com/ /puppetize-your-wordpress-install/](https://cloudifyblog.wordpress.com/2016/02/25/puppetize-your-wordpress-install/)
### Master (master.puppet CentOS)
```bash
puppet module install hunner-wordpress --version 1.0.0
puppet module install puppet-php --version 6.0.2
puppet module install puppetlabs-apache --version 4.0.0
vim /etc/puppetlabs/code/environments/production/manifests/site.pp
```
```
node 'alpha.puppet' {
        include blog
}
```
```bash
vim /etc/puppetlabs/code/environments/production/manifests/blog.pp
```
```
class blog {
  notify {"Installing wordpress":}

  class { 'apache':
    docroot => '/opt/wordpress'
  }

  class {'apache::mod::php': }

  class { '::mysql::server':
    root_password           => 'strongpassword',
    remove_default_accounts => true,
  }

  class {'mysql::bindings':
    php_enable => true
  }

  class { 'wordpress': }
}
```
### Marionnette (alpha.puppet CentOS)
```bash
yum install wget
/opt/puppetlabs/bin/puppet agent -t
yum install lynx
lynx alpha.puppet:80
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
```

### Master
```bash
lynx alpha.puppet:80
```