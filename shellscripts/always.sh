#!/bin/bash

#HTTPD CONF
HTTPD_CONF="/etc/apache2/sites-enabled/${SITE_NAME}.conf"
if [ ! -z "$APACHE2_CONF_PATH" ] && [ -e "$APACHE2_CONF_PATH" ] 
then
    sudo cp ${APACHE2_CONF_PATH} $HTTPD_CONF
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

    LogLevel alert rewrite:trace6

</VirtualHost>
" | sudo tee $HTTPD_CONF
fi

sudo service apache2 restart 

