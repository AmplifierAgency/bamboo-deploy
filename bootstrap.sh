#!/bin/bash

imageVer=3.1

locale-gen en_AU.UTF-8

# Enable the multiverse repos
sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list

# enable JDK repos
add-apt-repository -y ppa:webupd8team/java

apt-get -y update 
apt-get -y upgrade
apt-get -y install unzip git ppa-purge puppet-common ec2-api-tools
apt-get -y clean
apt-get -y update
apt-get -y install oracle-java7-installer
update-java-alternatives -s java-7-oracle
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get -y install oracle-java7-set-default
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
ssh-keygen -b 4096 -t rsa -f /root/.ssh/id_rsa -P ""

# Add the bamboo user
useradd -m bamboo 

cd /tmp
# Downloading agent installer to the instance
wget https://maven.atlassian.com/content/repositories/atlassian-public/com/atlassian/bamboo/atlassian-bamboo-elastic-image/${imageVer}/atlassian-bamboo-elastic-image-${imageVer}.zip
mkdir -p /opt/bamboo-elastic-agent
unzip -o atlassian-bamboo-elastic-image-${imageVer}.zip -d /opt/bamboo-elastic-agent
chown -R bamboo /opt/bamboo-elastic-agent
chmod -R u+r+w /opt/bamboo-elastic-agent
 
# Instance configuration
 chown -R bamboo:bamboo /home/bamboo/
 
# Configure path variables
echo "export PATH=/opt/bamboo-elastic-agent/bin:\$PATH" > /etc/profile.d/bamboo.sh
 
# Configure automatic startup of the Bamboo agent (add before line 14 of /etc/rc.local)
sed -i '14 i . /opt/bamboo-elastic-agent/etc/rc.local' /etc/rc.local
 
# Welcome screen
cp /opt/bamboo-elastic-agent/etc/motd /etc/motd
echo bamboo-5.0.2  >> /etc/motd

# bootstrap the puppet configuration
cd /home/bamboo
git clone git@github.com:AmplifierAgency/bamboo-puppet.git /home/bamboo/puppet
git clone git@github.com:AmplifierAgency/bamboo-deploy.git /home/bamboo/deploy

chown -R bamboo:bamboo /home/bamboo/
chmod -R u+r+w /home/bamboo/
 
exit 0
