#!/bin/bash

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-1.7.list
sudo apt-get update && sudo apt-get install -y openjdk-7-jdk elasticsearch

sudo echo "script.engine.groovy.inline.aggs: on" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo echo "network.bind_host: 0" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults
