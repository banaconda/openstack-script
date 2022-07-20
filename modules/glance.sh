mysql -e "CREATE DATABASE glance;"
mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DBPASS';"

openstack user create --domain default --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image

openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

apt install -y glance

cp ../etc/glance/glance-api.conf /etc/glance/glance-api.conf
su -s /bin/sh -c "sed -i 's/GLANCE_DBPASS/$GLANCE_DBPASS/g' /etc/glance/glance-api.conf"
su -s /bin/sh -c "sed -i 's/GLANCE_PASS/$GLANCE_PASS/g' /etc/glance/glance-api.conf"

su -s /bin/sh -c "glance-manage db_sync" glance

service glance-api restart

