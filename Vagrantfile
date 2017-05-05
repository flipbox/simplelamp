# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

unless Vagrant.has_plugin?("vagrant-hostmanager")
    raise 'vagrant-hostmanager is required! Run `vagrant plugin install vagrant-hostmanager`'
end

Vagrant.require_version ">= 1.8.1"

userconfigs = YAML::load_file(File.join(__dir__, 'config.yml'))

#CHECK FOR OVERWRITE
if userconfigs.key?('overwrite')
    configfile = File.join(__dir__, userconfigs['overwrite'])

    if File.file?(configfile)
        userconfigs = YAML::load_file(configfile)
    end
end

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# There is no need to edit anything in this file
# Please use the config.yml to configure the vagrant box
# Request features here: https://github.com/FlipboxFactory/simplelamp
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PROJECT NAME (NAME AND HOSTNAME)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ** REQUIRED ** if you have multiple instances of this, change the project name!!
if userconfigs.key?('name')
    PROJECT_NAME = userconfigs['name']
else
    raise '`name` in config.yml file is required.'
end


if userconfigs.key?('phpVersion')
    PHP_VERSION = userconfigs['phpVersion']
else
    raise '`phpVersion` in config.yml file is required.'
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PROJECT PATH (REMOTE AND LOCAL)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if userconfigs.key?('remote_path')
    REMOTE_PROJECT_PATH = userconfigs['remote_path']
else
    REMOTE_PROJECT_PATH = "/var/www/html/"
end

# ** REQUIRED ** if your project directory looks like the below, you really don't need to change much more than this.
#example: LOCAL_PROJECT_PATH = "/users/home/sites/myproject"
# $ ls /users/home/sites/myproject
#       craft
#       public
#       README.md
if userconfigs.key?('local_path')
    LOCAL_PROJECT_PATH = userconfigs['local_path']
else
    raise '`local_path` in config.yml file is required.'
end
#vm path to the public directory

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OPTION #1: SITES HASH
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
site_aliases = []

if userconfigs.key?('sites')
    userconfigs['sites'].each do | name, httpconf |
        site_aliases.push(*httpconf['domains'])
    end
else
    raise '`sites` in config.yml file is required.'
end 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OPTION #2: REMOTE PATH FOR APACHE CONF (this is not tested)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#vm path to the apache conf you want to use 
# ** OPTIONAL ** if this is left `nil`, this default will be used (found in shellscripts/always.sh)
if userconfigs.key?('httpconf')
    APACHE2_CONF_PATH = userconfigs['httpconf']
else
    APACHE2_CONF_PATH = nil
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OPTION #3: DB INSTALLS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# INSTALL
if userconfigs.key?('install') and userconfigs['install'].key?('elasticsearch') and userconfigs['install']['elasticsearch']
    INSTALL_ELASTICSEARCH = userconfigs['install']['elasticsearch']
else
    INSTALL_ELASTICSEARCH = nil
end

# MYSQL INSTALLS BY DEFAULT
# MYSQL IS INSTALLED BY DEFAULT, SET TO FALSE IF THIS IS NOT WANTED
if userconfigs.key?('install') and userconfigs['install'].key?('mysql')
    INSTALL_MYSQL = userconfigs['install']['mysql']
else
    INSTALL_MYSQL = true
end

# POSTGRESQL INSTALL
if userconfigs.key?('install') and userconfigs['install'].key?('postgresql')
    INSTALL_POSTGRESQL = userconfigs['install']['postgresql']
else
    INSTALL_POSTGRESQL = nil
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PLUGINS DIRECTORY (REMOTE AND LOCAL, this is not tested)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#You developing a bunch of plugins?
# This is great for testing plugins all at once!
# If your project path matchs this you shouldn't have to change this.
REMOTE_PLUGINS_DIRECTORY = [REMOTE_PROJECT_PATH, "craft/plugins"].join('/')

# ** OPTIONAL ** if this is left `nil`, this directory will not be mounted 
if userconfigs.key?('craft_plugins') and userconfigs['craft_plugins'].key?('local_path')
    LOCAL_PLUGINS_DIRECTORY = userconfigs['craft_plugins']['local_path']
else
    LOCAL_PLUGINS_DIRECTORY = nil
end

#database properties
DATABASE_LOCATION = nil # if you want to make the provisioning load a db dump... uncomment this -> #REMOTE_PROJECT_PATH + "_db/craft.sql"

# TODO - add these as options to the configs
DB_NAME        = "craft"
DB_USER        = "vagrant"
DB_PASS        = "vagrant"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# VM PROPERTIES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TODO - Dynamically calculate memory usage.
MAX_MEM = 4096
MAX_CPUS = 2

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#Random test comment
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # All Vagrant configuration is done here. The most common configuration
    # options are documented and commented below. For a complete reference,
    # please see the online documentation at vagrantup.com.

    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "ubuntu/trusty64"

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    config.vm.synced_folder "./", "/vagrant" #type: "nfs", owner: "apache", group: "apache"
    config.vm.synced_folder LOCAL_PROJECT_PATH, REMOTE_PROJECT_PATH , type: "nfs"#, nfs_export: true#, owner: "apache", group: "apache"#, type: "nfs",

    if LOCAL_PLUGINS_DIRECTORY
        config.vm.synced_folder LOCAL_PLUGINS_DIRECTORY, REMOTE_PLUGINS_DIRECTORY, type: "nfs"#, nfs_export: true#, owner: "apache", group: "apache"#, type: "nfs",
    end

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    config.vm.provider "virtualbox" do |vb|
        # Set the name that appears in VirtualBox Manager
        vb.name = PROJECT_NAME
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--memory", MAX_MEM]
        vb.cpus = MAX_CPUS
    end

    config.vm.provision "shell" do |s|
        s.name = "PHP" 
        s.path = "shellscripts/php-apache2.sh"
        s.env = {
            "PHP_VERSION" => PHP_VERSION
        }
    end

    if INSTALL_POSTGRESQL
        config.vm.provision "shell" do |s|
            s.name = "POSTGRESQL" 
            s.path = "shellscripts/postgresql.sh"
            s.env = {
                "DB_NAME"      => DB_NAME,
                "DB_USER"      => DB_USER,
                "DB_PASS"      => DB_PASS,
                "DATABASE_LOCATION" => DATABASE_LOCATION
            }
        end
    end

    if INSTALL_MYSQL
        config.vm.provision "shell" do |s|
            s.name = "MYSQL" 
            s.path = "shellscripts/mysql.sh"
            s.env = {
                "DB_NAME"      => DB_NAME,
                "DB_USER"      => DB_USER,
                "DB_PASS"      => DB_PASS,
                "DATABASE_LOCATION" => DATABASE_LOCATION
            }
        end
    end
    
    userconfigs['sites'].each do |sitename, httpconfigs|
        # print "Running ByPathAndHosts-"+sitename+" for " + httpconfigs['docroot'] + "\n"
        config.vm.provision "shell", run: "always" do |s|
            s.name = "ByPathAndHosts-"+sitename
            s.path = "shellscripts/always.sh"
            s.env = {
                "REMOTE_PATH"       => httpconfigs['docroot'],
                "PROJECT_HOSTNAMES" => httpconfigs['domains'].join(' '),
                "SITE_NAME"   => sitename,
                "APACHE2_FORCE_HTTPS" => httpconfigs.key?('force_https') ? ( httpconfigs['force_https'] ? "yes" : "no" ) : "no"
            }
        end
    end
    if APACHE2_CONF_PATH
        config.vm.provision "shell", run: "always" do |s|
            s.name = "ByConfFile" 
            s.path = "shellscripts/always.sh"
            s.env = {
                "APACHE2_CONF_PATH"    => APACHE2_CONF_PATH,
            }
        end
    end

    if INSTALL_ELASTICSEARCH
        config.vm.provision "shell" do |s|
            s.name = "ELASTICSEARCH"
            s.path = "shellscripts/elasticsearch.sh"
        end
    end


    # TODO - make hostmanager optional and check if it's installed
    config.vm.provision :hostmanager, run: "always" do |s|
        # Create a private network, which allows host-only access to the machine
            # using a specific IP.
            # config.vm.network "private_network", ip: PRIVATE_IP
            config.hostmanager.enabled = true
            config.hostmanager.manage_host = true
            config.hostmanager.ignore_private_ip = false
            config.hostmanager.include_offline = true
            config.vm.define PROJECT_NAME do |node|
                node.vm.network "private_network", type: "dhcp"
                node.vm.hostname = PROJECT_NAME
                node.hostmanager.aliases = site_aliases
                node.hostmanager.ip_resolver = proc do |vm, resolving_vm|
                    if hostname = (vm.ssh_info && vm.ssh_info[:host])
                        `vagrant ssh -c "/sbin/ifconfig eth1" | grep "inet addr" | tail -n 1 | egrep -o "[0-9\.]+" | head -n 1 2>&1`.split("\n").first[/(\d+\.\d+\.\d+\.\d+)/, 1]
                    end
                end
            end
    end

end
