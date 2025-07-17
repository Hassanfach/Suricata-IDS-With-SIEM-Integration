#!/bin/bash
# Configure Elasticsearch
PRIVATE_IP=$1
INTERFACE=$2
sudo sed -i "s/#network.host: 192.168.0.1/network.bind_host: [\"127.0.0.1\", \"$PRIVATE_IP\"]/g" /etc/elasticsearch/elasticsearch.yml
echo -e "discovery.type: single-node\nxpack.security.enabled: true" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo ufw allow in on $INTERFACE
sudo ufw allow out on $INTERFACE
sudo systemctl start elasticsearch.service
