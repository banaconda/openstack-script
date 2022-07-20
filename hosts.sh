#!/bin/bash
su -s /bin/sh -c "echo '$MGMT_IP controller' >> /etc/hosts"
su -s /bin/sh -c "echo '$MGMT_IP compute1' >> /etc/hosts"
su -s /bin/sh -c "echo '$MGMT_IP block1' >> /etc/hosts"
su -s /bin/sh -c "echo '$MGMT_IP object1' >> /etc/hosts"
