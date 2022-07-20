mysql -e "CREATE DATABASE cinder;"
mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$CINDER_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$CINDER_DBPASS';"

openstack user create --domain default --password-prompt cinder
openstack role add --project service --user cinder admin
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3

openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s

apt install -y cinder-api cinder-scheduler
apt install -y lvm2 thin-provisioning-tools
apt install -y cinder-volume tgt

cp ../etc/cinder/cinder.conf /etc/cinder/cinder.conf

su -s /bin/sh -c "sed -i 's/CINDER_DBPASS/$CINDER_DBPASS/g' /etc/cinder/cinder.conf"
su -s /bin/sh -c "sed -i 's/CINDER_PASS/$CINDER_PASS/g' /etc/cinder/cinder.conf"
su -s /bin/sh -c "sed -i 's/RABBIT_PASS/$RABBIT_PASS/g' /etc/cinder/cinder.conf"
su -s /bin/sh -c "sed -i 's/MGMT_IP/$MGMT_IP/g' /etc/cinder/cinder.conf"

su -s /bin/sh -c "cinder-manage db sync" cinder

