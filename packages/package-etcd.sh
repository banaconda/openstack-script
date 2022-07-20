#!/bin/bash
apt install -y etcd
su -s /bin/sh -c "cp ../etc/default/etcd /etc/default/etcd"
su -s /bin/sh -c "sed -i 's/MGMT_IP/$MGMT_IP/g' /etc/default/etcd"
service etcd restart
