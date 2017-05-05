#!/bin/sh

###########################################################################
# PHP
###########################################################################
echo "${TEXT_BOLD}"
echo "Installing php, apache2, etc ----------------------------------------"
echo "${TEXT_NORM}"

read -d '' PHP_CONF <<EOF
memory_limit=256M
upload_max_filesize=100M
max_input_time=300
post_max_size=110M
max_input_vars=5000
max_execution_time=90

[xdebug]
zend_extension=xdebug.so
xdebug.default_enable = 1
xdebug.remote_enable = 1
xdebug.profiler_enable = 0
xdebug.remote_connect_back = 1
xdebug.show_mem_delta = 1
xdebug.trace_format = 2
xdebug.auto_trace = 0
xdebug.var_display_max_depth = 6
xdebug.profiler_enable_trigger = 1
xdebug.trace_enable_trigger = 1
xdebug.max_nesting_level = 500
xdebug.trace_output_dir = \"/var/www/html/_logs/xdebug\"
xdebug.profiler_output_dir = \"/var/www/html/_logs/xdebug\"

EOF

sayVersion() {
    echo "${TEXT_BOLD}"
    echo "Installing php version $1 ----------------------------------------"
    echo "${TEXT_NORM}"
}

# FUNCTIONS

# PHP 70
installPHP7() {
    sayVersion "7.0"
    sudo apt-get install -y php7.0-dev libapache2-mod-php7.0 php7.0-curl php7.0-cli php7.0-mcrypt php7.0-bcmath php7.0-gd php7.0-gmp php7.0-intl php7.0-mbstring php7.0-mysql php7.0-pgsql php7.0-soap php7.0-xml php7.0-zip php7.0-xsl php7.0-xmlrpc php-pear

    # Xdebug
    sudo apt-get update -y
    sudo pecl install pecl_http
    sudo pecl install Xdebug
    sudo echo "${PHP_CONF}" > /etc/php/7.0/apache2/conf.d/xdebug.ini
}

# PHP 71
installPHP71(){
    sayVersion "7.1"
    sudo apt-get install -y php7.1-dev libapache2-mod-php7.1 php7.1-curl php7.1-cli php7.1-mcrypt php7.1-bcmath php7.1-gd php7.1-gmp php7.1-intl php7.1-mbstring php7.1-mysql php7.1-pgsql php7.1-soap php7.1-xml php7.1-zip php7.1-xsl php7.1-xmlrpc php-pear

    sudo apt-get update -y
    sudo pecl install pecl_http
    sudo pecl install Xdebug
    sudo echo "${PHP_CONF}" >/etc/php/7.1/apache2/conf.d/00-site.ini
}


# PHP 56
installPHP56(){
    sayVersion "5.6"
    sudo apt-get install -y php5.6-dev libapache2-mod-php5.6 php5.6-curl php5.6-cli php5.6-mcrypt php5.6-bcmath php5.6-gd php5.6-gmp php5.6-intl php5.6-mbstring php5.6-mysql php5.6-pgsql php5.6-soap php5.6-xml php5.6-zip php5.6-xsl php5.6-xmlrpc php-pear

    sudo apt-get update -y
    sudo pecl install pecl_http
    sudo pecl install Xdebug
    sudo echo "${PHP_CONF}" >/etc/php/5.6/apache2/conf.d/00-site.ini
}

# PHP 55
installPHP55(){
    sayVersion "5.5"

    sudo apt-get install -y php5-dev php5-cli php5-common php5-cgi php5-intl php5-xmlrpc php5-gd php-soap php5-curl php5-mysqlnd php5-mcrypt php5-imagick libapache2-mod-php5 php-pear php5-xdebug
    sudo php5enmod mcrypt

    sudo apt-get update -y
    sudo echo "${PHP_CONF}" >/etc/php5/apache2/conf.d/00-site.ini
}

sudo add-apt-repository ppa:ondrej/php

sudo apt-get update -y 

#SWITCH THRU AND RUN WHICH EVER PHP VERSION WAS CHOSEN
case "$PHP_VERSION" in
    "7.1")
        installPHP71
        ;;
    "7.0")
        installPHP7
        ;;
    "5.6")
        installPHP56
        ;;
    "5.5")
        installPHP55
        ;;
    *)
        installPHP7
        ;;
esac

#install apache
sudo apt-get install -y apache2
sudo a2enmod rewrite
sudo a2enmod ssl

#create a self signed cert to allow testing for ssl
sudo mkdir /etc/apache2/ssl/
sudo openssl req -subj '/CN=flipboxdigital.com/O=Flipbox Digital/C=US' -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout /etc/apache2/ssl/server.key -out /etc/apache2/ssl/server.crt


###########################################################################
# FINISH
###########################################################################
