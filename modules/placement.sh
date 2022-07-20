mysql -e "CREATE DATABASE placement;"
mysql -e "GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY '$PLACEMENT_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY '$PLACEMENT_PASS';"

openstack user create --domain default --password-prompt placement
openstack role add --project service --user placement admin

openstack service create --name placement --description "Placement API" placement

openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778

apt install -y placement-api

cp ../etc/placement/placement.conf /etc/placement/placement.conf
su -s /bin/sh -c "sed -i 's/PLACEMENT_PASS/$PLACEMENT_PASS/g' /etc/placement/placement.conf "
su -s /bin/sh -c "sed -i 's/PLACEMENT_DBPASS/$PLACEMENT_PASS/g' /etc/placement/placement.conf "

su -s /bin/sh -c "placement-manage db sync" placement
service apache2 restart
