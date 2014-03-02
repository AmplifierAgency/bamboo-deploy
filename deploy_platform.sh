#!/bin/bash

# lets install everything we need
cd /home/bamboo/puppet
git pull
puppet apply --modulepath=/home/bamboo/puppet/modules/ /home/bamboo/puppet/manifests/default.pp

/bin/sh /home/bamboo/puppet/shell/updateAndroidSDK.sh
/bin/sh /home/bamboo/puppet/shell/getGeolocationData.sh

exit 0
