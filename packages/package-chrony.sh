#!/bin/bash
apt install -y chrony
su -s /bin/sh -c "echo 'server $MGMT_IP' >> /etc/chrony/chrony.conf"
service chrony restart
chronyc sources
