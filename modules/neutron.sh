mysql -e "CREATE DATABASE neutron;"
mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$NEUTRON_DBPASS';"
mysql -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$NEUTRON_DBPASS';"

openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin

openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

apt install neutron-server neutron-plugin-ml2 \
  neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent \
  neutron-metadata-agent

cp -r ../etc/neutron /etc/

su -s /bin/sh -c "sed -i 's/NEUTRON_DBPASS/$NEUTRON_DBPASS/g' /etc/neutron/neutron.conf"
su -s /bin/sh -c "sed -i 's/NEUTRON_PASS/$NEUTRON_PASS/g' /etc/neutron/neutron.conf"
su -s /bin/sh -c "sed -i 's/RABBIT_PASS/$RABBIT_PASS/g' /etc/neutron/neutron.conf"
su -s /bin/sh -c "sed -i 's/NOVA_PASS/$NOVA_PASS/g' /etc/neutron/neutron.conf"
su -s /bin/sh -c "sed -i 's/PROVIDER_INTERFACE_NAME/$PROVIDER_INTERACE_NAME/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini"
su -s /bin/sh -c "sed -i 's/OVERLAY_INTERFACE_IP_ADDRESS/$OVERLAY_INTERFACE_IP_ADDRESS/g' /etc/neutron/plugins/ml2/linuxbridge_agent.ini"
su -s /bin/sh -c "sed -i 's/METADATA_SECRET/$METADATA_SECRET/g' /etc/neutron/metadata_agent.ini"

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

service nova-api restart
service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart
service neutron-l3-agent restart
