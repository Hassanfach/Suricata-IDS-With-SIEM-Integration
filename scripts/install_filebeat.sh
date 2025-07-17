#!/bin/bash
# Install and configure Filebeat
PRIVATE_IP=$1
ELASTIC_PASSWORD=$2
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install -y filebeat
sudo sed -i "s/#host: \"localhost:5601\"/host: \"$PRIVATE_IP:5601\"/g" /etc/filebeat/filebeat.yml
sudo sed -i "s/hosts: \[\"localhost:9200\"\]/hosts: [\"$PRIVATE_IP:9200\"]/g" /etc/filebeat/filebeat.yml
sudo sed -i 's/#username: "elastic"/username: "elastic"/g' /etc/filebeat/filebeat.yml
sudo sed -i "s/#password: \"changeme\"/password: \"$ELASTIC_PASSWORD\"/g" /etc/filebeat/filebeat.yml
sudo filebeat modules enable suricata
sudo filebeat setup
sudo systemctl start filebeat.service
