#!/bin/bash

#HTTPD CONF
HTTPD_CONF="/etc/apache2/sites-enabled/${SITE_NAME}.conf"
if [ ! -z "$APACHE2_CONF_PATH" ] && [ -e "$APACHE2_CONF_PATH" ] 
then
    sudo cp ${APACHE2_CONF_PATH} $HTTPD_CONF
else
    if [ "$APACHE2_FORCE_HTTPS" = "yes" ]
    then
    sudo echo "
<Directory \"${REMOTE_PATH}\">
    DirectoryIndex index.php index.html index.htm
    ErrorDocument 404 index.php
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
</Directory>

<VirtualHost *:80>

    DocumentRoot ${REMOTE_PATH}
    #this really doesn't matter aliases are taking care of the routing
    ServerName dummy.com 
    ServerAlias ${PROJECT_HOSTNAMES}

    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    # This checks to make sure the connection is not already HTTPS

    RewriteRule ^/?(.*) https://%{SERVER_NAME}/\$1 [R,L]

    LogLevel info rewrite:trace6

</VirtualHost>
<VirtualHost *:443>

    DocumentRoot ${REMOTE_PATH}
    #this really doesn't matter aliases are taking care of the routing
    ServerName dummy.com
    ServerAlias ${PROJECT_HOSTNAMES}

    RewriteEngine On

    LogLevel info rewrite:trace6

    SSLEngine on
    SSLCertificateFile    /etc/apache2/ssl/server.crt
    SSLCertificateKeyFile /etc/apache2/ssl/server.key

</VirtualHost>
" | sudo tee $HTTPD_CONF;

    else
    sudo echo "
<Directory \"${REMOTE_PATH}\">
    DirectoryIndex index.php index.html index.htm
    ErrorDocument 404 index.php
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
</Directory>

<VirtualHost *:80>

    DocumentRoot ${REMOTE_PATH}
    #this really doesn't matter aliases are taking care of the routing
    ServerName dummy.com 
    ServerAlias ${PROJECT_HOSTNAMES}

    RewriteEngine On

    LogLevel info rewrite:trace6

</VirtualHost>
<VirtualHost *:443>

    DocumentRoot ${REMOTE_PATH}
    #this really doesn't matter aliases are taking care of the routing
    ServerName dummy.com
    ServerAlias ${PROJECT_HOSTNAMES}

    RewriteEngine On

    LogLevel info rewrite:trace6

    SSLEngine on
    SSLCertificateFile    /etc/apache2/ssl/server.crt
    SSLCertificateKeyFile /etc/apache2/ssl/server.key

</VirtualHost>
" | sudo tee $HTTPD_CONF;
    fi;
fi

sudo service apache2 restart 

