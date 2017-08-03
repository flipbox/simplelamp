# Simple LAMP

## Description
This vagrant setup is a simple LAMP implementation to get you started with building, testing, and maintaining LAMP projects and more. The purpose is to have something light weight compared to the other vagrant php boxes like Homestead. Fork me!

## What's in the Box?
- [ubuntu/trusty64 on Ubuntu 14.04](https://atlas.hashicorp.com/ubuntu/boxes/trusty64)
- Apache 2.4
- PHP 7.0.11
    - Modules

        - [PHP Modules] bcmath calendar Core ctype date dom exif fileinfo filter ftp gd gettext gmp hash iconv intl json libxml mbstring mcrypt mysqli mysqlnd openssl pcntl pcre PDO pdo_mysql Phar posix readline Reflection session shmop SimpleXML soap sockets SPL standard sysvmsg sysvsem sysvshm tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl Zend OPcache zip zlib
        - [Zend Modules] Zend OPcache
- MySQL 5.6.28

## Requirements
- Mac OSX/Linux (this probably won't work well with Windows but I haven't tested it)
- Vagrant 1.8.1
- VirtualBox
- vagrant plugins:
	- vagrant-hostmanager
		- install by running `vagrant plugin install vagrant-hostmanager`
- NFS mounting
	- Feel free to change this by searching the Vagrantfile and removing nfs in the shared folders area. 

## Getting Started
To get started, make sure all of the requirements about are fulfilled and edit the config.yml file directly. YOU MUST EDIT THE config.yml FILE FOR THIS SETUP TO WORK. Documentation to come.

Once the config.yml file is edited, you can run:

`vagrant up`

## Config File (config.yml)

### Properties
- *name* (required) - string - Change this to fit the name of the project you are working on.
- *overwrite* (optional) - string - Path to a config.yml that will overwrite it completely. This is nice if you want to use this repo as a git submodule.
- *local_path* (required) - string - the local path to the project root. The project root will have anything that might be needed to be accessed from the server. This is not the document root for apache.
- *remote_path* (required) - string - the remote path to the project on the vagrant box.
- *phpVersion* - enum - options are php versions (list is space sperated) 7.1 7.0 5.6 5.5
- *sites* (required) - array - the apache config variables for the infinite amount of virtual hosts you want to run on the vagrant box.
    - site name - You name this key and can be whatever you want it to be. An example of having multiple sites is when you have an api and a web entry point. The site names could be "web" and "api"
        - *docroot* (required) - string - Value for the apache virtual host DocumentRoot. This is the remote path, the path that is on the vagrant box.
        - *domains* (required) - array - Value for the apache virtual host ServerAlias. Currently we don't set the ServerName for the apache virtual host which is fine when we have the aliases that are correct.
        - *force_https* (optional) - boolean value - Added a redirect from http to https when true.
- *install* 
	- *elasticsearch* - bool - install server or not
	- *msyql* - bool - install server or not
	- *postgresql* - bool - install server or not

#### Example config.yml
```yaml
# vi:syntax=yaml ft=yaml
# Project name
name: example
overwrite: ../.simplelamp.yml
# Project paths
# path on you computer, we like to commit the Vagrantfile and dependencies to the project repo.
local_path: ../
# path on the vagrant box
remote_path: /var/www/html
# options: 7.1 7.0 5.6 5.5
phpVersion: 7.1
# Sites
sites:
    # site label, you can have unlimited sets of sites childern
    example:
        # this can also have a local path for the http conf
        docroot: /var/www/html/public
        domains:
            - example.dev
	    - local.example.com
        #boolean
        force_https: true

install:
    elasticsearch: false
    mysql: true
    postgresql: false

```

## Disclaimer
This is for development purposes only. Please don't use this in production and read the LICENSE


