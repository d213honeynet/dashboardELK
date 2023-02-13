#!/bin/bash

# Install Prerequisites
sudo apt-get update
sudo apt-get install default-jdk nginx
sudo systemctl enable nginx

# Install ELK
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update
sudo apt-get install elasticsearch logstash kibana filebeat
sudo systemctl enable elasticsearch logstash kibana filebeat

sudo cp config/elasticsearch.yml /etc/elasticsearch
sudo cp config/logstash.yml /etc/logstash
sudo cp config/kibana.yml /etc/kibana
sudo cp config/filebeat.yml /etc/filebeat
sudo cp config/config_log.conf /etc/logstash/conf.d && sudo chown $USER:$USER /etc/logstash/conf.d/config_log.conf
sudo cp config/proto.csv /var/log/logstash && sudo chown $USER:$USER /var/log/logstash/proto.csv

sudo systemctl restart elasticsearch logstash kibana filebeat
