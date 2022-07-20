apt install -y openstack-dashboard

cp ../etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py

service apache2 restart
