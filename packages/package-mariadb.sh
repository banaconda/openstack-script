#!/bin/bash
apt install -y mariadb-server python3-pymysql
su -s /bin/sh -c "cp -r ../etc/mysql /etc"
su -s /bin/sh -c "sed -i 's/MGMT_IP/$MGMT_IP/g' /etc/mysql/mariadb.conf.d/99-openstack.cnf"
service mysql restart
