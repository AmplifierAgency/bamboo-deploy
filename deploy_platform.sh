#!/bin/bash

# bootstrap the puppet configuration
cd /home/bamboo
git clone git@github.com:AmplifierAgency/bamboo-puppet.git /home/bamboo/puppet
git clone git@github.com:AmplifierAgency/bamboo-deploy.git /home/bamboo/deploy

chown -R bamboo:bamboo /home/bamboo/
chmod -R u+r+w /home/bamboo/

# lets install everything we need
cd /home/bamboo/puppet
git pull
puppet apply --modulepath=/home/bamboo/puppet/modules/ /home/bamboo/puppet/manifests/default.pp

/bin/sh /home/bamboo/puppet/shell/updateAndroidSDK.sh
/bin/sh /home/bamboo/puppet/shell/getGeolocationData.sh

exit 0
