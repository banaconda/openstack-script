#!/bin/bash
apt install -y rabbitmq-server
su -s /bin/sh -c "rabbitmqctl add_user openstack $RABBIT_PASS"
su -s /bin/sh -c 'rabbitmqctl set_permissions openstack ".*" ".*" ".*"'

