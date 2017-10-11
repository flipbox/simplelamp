#!/bin/bash

sayVersion() {
    echo "${TEXT_BOLD}"
    echo "Installing elasticsearch version $1 ----------------------------------------"
    echo "${TEXT_NORM}"
}

# ES 5
installES5(){
    sayVersion "5"

    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
    sudo add-apt-repository ppa:openjdk-r/ppa && \
    sudo apt-get update && \
    sudo apt-get install -y openjdk-8-jdk elasticsearch
}

# ES 23
installES2(){
    sayVersion "2"

    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb https://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
    sudo apt-get update && \
        sudo apt-get install -y openjdk-7-jdk elasticsearch

}

# ES 1.7
installES17(){
    sayVersion "1.7"

    wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-1.7.list
    sudo apt-get update && \
        sudo apt-get install -y openjdk-7-jdk elasticsearch

    sudo echo "script.engine.groovy.inline.aggs: on" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
}

#SWITCH THRU AND RUN WHICH EVER PHP VERSION WAS CHOSEN
case "$ES_VERSION" in
    "5")
        installES5
        ;;
    "2")
        installES23
        ;;
    "1.7")
        installES17
        ;;
    *)
        installES5
        ;;
esac


sudo echo "network.bind_host: 0" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults
