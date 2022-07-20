#!/bin/bash

echo $MGMT_IP
apt install -y memcached python3-memcache
su -s /bin/sh -c "cp ../etc/memcached.conf /etc/memcached.conf"
su -s /bin/sh -c "sed -i 's/MGMT_IP/$MGMT_IP/g' /etc/memcached.conf"
service memcached restart
