#!/bin/bash
# Configure Kibana
PRIVATE_IP=$1
KIBANA_SYSTEM_PASSWORD=$2
sudo sed -i "s/#server.host: \"localhost\"/server.host: \"$PRIVATE_IP\"/g" /etc/kibana/kibana.yml
echo -e "xpack.encryptedSavedObjects.encryptionKey: 66fbd85ceb3cba51c0e939fb2526f585\nxpack.reporting.encryptionKey: 9358f4bc7189ae0ade1b8deeec7f38ef\nxpack.security.encryptionKey: 8f847a594e4a813c4187fa93c884e92b" | sudo tee -a /etc/kibana/kibana.yml
cd /usr/share/kibana/bin/
echo "kibana_system" | sudo ./kibana-keystore add elasticsearch.username
echo "$KIBANA_SYSTEM_PASSWORD" | sudo ./kibana-keystore add elasticsearch.password
sudo systemctl start kibana.service
