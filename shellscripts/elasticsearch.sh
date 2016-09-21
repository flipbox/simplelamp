#!/bin/bash

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get update && sudo apt-get install -y openjdk-7-jdk elasticsearch

sudo echo "network.bind_host: 0" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo service elasticsearch restart
sudo systemctl enable elasticsearch.service
