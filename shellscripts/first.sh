#!/bin/sh

###########################################################################
# PHP
###########################################################################
echo "${TEXT_BOLD}"
echo "Installing php, apache2, etc ----------------------------------------"
echo "${TEXT_NORM}"

#should be php 70
# sudo add-apt-repository ppa:ondrej/php
sudo apt-get update -y
#TODO - Make php version configurable
sudo apt-get install -y php5-dev php5-cli php5-common php5-cgi php5-intl php5-xmlrpc php5-gd php-soap php5-curl php5-mysqlnd php5-mcrypt php5-imagick libapache2-mod-php5 php-pear php5-xdebug
sudo php5enmod mcrypt


#install apache
sudo apt-get install -y apache2 
sudo a2enmod rewrite
sudo a2enmod ssl

#create a self signed cert to allow testing for ssl
sudo mkdir /etc/apache2/ssl/
sudo openssl req -subj '/CN=flipboxdigital.com/O=Flipbox Digital/C=US' -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout /etc/apache2/ssl/server.key -out /etc/apache2/ssl/server.crt

#TODO - Make php xdebug configurable
# Xdebug
# sudo apt-get update -y
# sudo pecl install pecl_http
# sudo pecl install Xdebug
sudo echo "[xdebug]
zend_extension=xdebug.so
xdebug.idekey = "PHPSTORM"
xdebug.default_enable = 1
xdebug.remote_enable = 1
xdebug.profiler_enable = 0
xdebug.remote_connect_back = 1
xdebug.show_mem_delta = 1
xdebug.trace_format = 2
xdebug.auto_trace = 0
xdebug.var_display_max_depth = 6
xdebug.var_display_max_children = 256
xdebug.var_display_max_data = 1024
xdebug.profiler_enable_trigger = 1
xdebug.trace_enable_trigger = 1
xdebug.max_nesting_level = 500
xdebug.trace_output_dir = "/var/www/html/_logs/xdebug"
xdebug.profiler_output_dir = "/var/www/html/_logs/xdebug"

memory_limit=256M
upload_max_filesize=100M
max_input_time=300
post_max_size=110M
max_input_vars=5000
max_execution_time=90">/etc/php5/apache2/conf.d/00-site.ini
###########################################################################
# MYSQL
###########################################################################
echo "${TEXT_BOLD}"
echo "MYSQL ----------------------------------------------------------------------"
echo "${TEXT_NORM}"

echo "mysql-server mysql-server/root_password password ${DB_PASS}" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${DB_PASS}" | sudo debconf-set-selections
sudo apt-get -y install mysql-server-5.6

sudo update-rc.d mysql defaults
sudo update-rc.d apache2 defaults

# Create the database
mysql -u root -p$DB_PASS -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;"

# Create the user
mysql -u root -p$DB_PASS -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -p$DB_PASS -e "GRANT ALL PRIVILEGES ON ${DB_NAME} . * TO '${DB_USER}'@'localhost';"

if [ ! -z "$DATABASE_LOCATION" ] && [ -e "$DATABASE_LOCATION" ]
then
    #DATABASE_LOCATION file exists, load
    echo "Loading DB at ${DATABASE_LOCATION}";
    mysql -u root -p$DB_PASS $DB_NAME < $DATABASE_LOCATION && echo "DB at ${DATABASE_LOCATION} loaded successfully.";
fi

###########################################################################
# FINISH
###########################################################################
