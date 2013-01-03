#!/bin/sh
# Source: user-data.sh
# Purpose: Script to paste user-data into the AWS console's instance launch form.
#          This will perform the following steps:
#             1. Install puppet
#	      2. Install Apache2 and PHP
#             3. Configure Apache HTTPD with a virtual host that will respond to a request for candidateeval.ithaka.org 
#             4. Alias httpd to apache2
#             5. Move default web files into place (index.html)
#             6. Start httpd (apache2) services.
# Author: Marci Wojcik

# Online Resource References:
# Ken Rimey: http://blog.codento.com/2012/02/hello-ec2-part-1-bootstrapping-instances-with-cloud-init-git-and-puppet/
# Nicholas Zakas: http://www.nczonline.net/blog/2011/07/21/quick-and-dirty-spinning-up-a-new-ec2-web-server-in-five-minutes/
# Eric Hammond: http://alestic.com/2012/05/aws-command-line-packages

#puppet_source='https://github.com/fgrehm/ubuntu-puppet-git.git'
puppet_source='https://bitbucket.org/rimey/hello-ec2-puppetboot.git'

set -e -x

#Update package lists
sudo apt-get update


#install apache
sudo apt-get --yes update
sudo apt-get --yes install apache2


#install php 
sudo apt-get -y install php5
sudo apt-get -y install libapache2-mod-php5

#stop apache2 (httpd)
sudo service apache2 stop

#start apache web server
sudo service apache2 start

#sudo /etc/init.d/apache2 restart

# set httpd alias to apache2
alias httpd='apache2'

# 12.04 LTS Precise, 11.10 Oneiric
sudo perl -pi.orig -e   'next if /-backports/; s/^# (deb .* multiverse)$/$1/'   /etc/apt/sources.list

# 10.04 LTS Lucid
sudo perl -pi.orig -e   's/^(deb .* universe)$/$1 multiverse/'   /etc/apt/sources.list

sudo apt-add-repository ppa:awstools-dev/awstools
sudo apt-get update


sudo apt-get install ec2-api-tools ec2-ami-tools iamcli rdscli

# Also available on Ubuntu 12.04 LTS Precise
sudo apt-get install aws-cloudformation-cli elbcli

#fix install errors for ec2-api-tools
sudo apt-get update  

#reinstall the ec2-api-tools
sudo apt-get install ec2-api-tools  

<<<<<<< HEAD
#!/bin/bash 
# enable multiverse, unless it already is
has_multi=`grep multiverse /etc/apt/sources.list`
if [ "" = "$has_multi" ] ; then
echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" >> /etc/apt/sources.list
echo "deb-src http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" >> /etc/apt/sources.list
echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid-updates multiverse" >> /etc/apt/sources.list
echo "deb-src http://us.archive.ubuntu.com/ubuntu/ lucid-updates multiverse" >> /etc/apt/sources.list
apt-get -y update
fi

cp index.html /var/www/.

sudo rm -rf /etc/puppet.orig
sudo apt-get --yes  update
sudo apt-get --yes  install git puppet-common

# obtain puppet configuration from public git repository.
sudo mv /etc/puppet /etc/puppet.orig
sudo git clone $puppet_source /etc/puppet

# Start puppet
sudo puppet apply /etc/puppet/manifests/init.pp

=======
>>>>>>> 62ffc4b1f63fb622eeebc06345238b90bbd5d2cb

