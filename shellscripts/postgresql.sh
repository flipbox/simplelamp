#!/bin/sh

###########################################################################
# POSTGRES
###########################################################################
echo "${TEXT_BOLD}"
echo "Installing POSTGRES ----------------------------------------"
echo "${TEXT_NORM}"

## SETUP SOME REPOS TO PULL FROM
#   - POSTGRES
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get update

###########################################################################
# DB
###########################################################################
echo "${TEXT_BOLD}"
echo "POSTGRES ----------------------------------------------------------------------"
echo "${TEXT_NORM}"

# SET PASSWORD TO THE PGPASSWORD
PGPASSWORD=$DB_PASS;

sudo apt-get -y install postgresql-9.6
#create user and db
sudo su - postgres -c "psql -c \"CREATE USER $DB_USER WITH PASSWORD '$PGPASSWORD';\""
sudo su - postgres -c "createdb $DB_NAME -O $DB_USER"


if [ ! -z "$DATABASE_LOCATION" ] && [ -e "$DATABASE_LOCATION" ]
then
    #DATABASE_LOCATION file exists, load
    echo "Loading DB at ${DATABASE_LOCATION}";
    psql -U $DB_USER -h localhost $DB_NAME < $DATABASE_LOCATION && echo "DB at ${DATABASE_LOCATION} loaded successfully.";
fi

###########################################################################
# FINISH
###########################################################################
