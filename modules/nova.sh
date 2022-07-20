mysql -e "CREATE DATABASE nova_api;"
mysql -e "CREATE DATABASE nova;"
mysql -e "CREATE DATABASE nova_cell0;"
mysql -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';"

openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

apt install -y nova-api nova-conductor nova-novncproxy nova-scheduler
apt install -y nova-compute

cp ../etc/nova/nova.conf /etc/nova/nova.conf
su -s /bin/sh -c "sed -i 's/MGMT_IP/$MGMT_IP/g' /etc/nova/nova.conf"
su -s /bin/sh -c "sed -i 's/NOVA_DBPASS/$NOVA_DBPASS/g' /etc/nova/nova.conf"
su -s /bin/sh -c "sed -i 's/NOVA_PASS/$NOVA_PASS/g' /etc/nova/nova.conf"
su -s /bin/sh -c "sed -i 's/RABBIT_PASS/$RABBIT_PASS/g' /etc/nova/nova.conf"
su -s /bin/sh -c "sed -i 's/PLACEMENT_PASS/$PLACEMENT_PASS/g' /etc/nova/nova.conf"
su -s /bin/sh -c "sed -i 's/NEUTRON_PASS/$NEUTRON_PASS/g' /etc/nova/nova.conf"
su -s /bin/sh -c "sed -i 's/METADATA_SECRET/$METADATA_SECRET/g' /etc/nova/nova.conf"

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova

service nova-api restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart
service nova-compute restart

openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

