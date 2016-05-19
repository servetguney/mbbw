#!/bin/bash

# Configuration.
CONFIGFILE="./config.php"
SETTINGSFILE="./settings.php"
DUMPFILE="./mysqldump.sql"
ROOTDOC="/var/www/html"

# Goto ROOTDOC

# Clean-up and copy files.
rm -rf "$ROOTDOC"/*
cp -r "$DATASOURCE"/* "$ROOTDOC"/


# List of the variables:
# 1. DOMAIN
# 2. DATABASE NAME
# 2. DATABASE PORT
# 4. DATABASE HOSTNAME
# 5. DATABASE USER
# 6. DATABASE PASSWORD

MYBB_DOMAINNAME="${1}"
MYBB_DBNAME="${2}"
MYBB_DBPORT="${3}"
MYBB_DBHOSTNAME="${4}"
MYBB_DBUSERNAME="${5}"
MYBB_DBPASSWORD="${6}"

# Prepare and copy dynamic configuration files.
sed -e "s/MYBB_DOMAINNAME/${MYBB_DOMAINNAME}/g" \
    "${SETTINGSFILE}" > "${ROOTDOC}/inc/settings.php"

sed -e "s/MYBB_DBNAME/${MYBB_DBNAME}/g" \
    -e "s/MYBB_DBUSERNAME/${MYBB_DBUSERNAME}/g" \
    -e "s/MYBB_DBPASSWORD/${MYBB_DBPASSWORD}/g" \
    -e "s/MYBB_DBHOSTNAME/${MYBB_DBHOSTNAME}/g" \
    -e "s/MYBB_DBPORT/${MYBB_DBPORT}/g" \
    "${CONFIGFILE}" > "${ROOTDOC}/inc/config.php"

# Initialize database.
sed -e "s/MYBB_DOMAINNAME/${MYBB_DOMAINNAME}/g" \
    "${DUMPFILE}" | mysql \
    --user="$MYBB_DBUSERNAME" \
    --password="$MYBB_DBPASSWORD" \
    --host="$MYBB_DBHOSTNAME" \
    --port="$MYBB_DBPORT" \
    --database="$MYBB_DBNAME" || echo "Ignore Errors"

cd "$ROOTDOC"
chown www-data:www-data *
chmod 666 inc/config.php inc/settings.php
chmod 666 inc/languages/english/*.php inc/languages/english/admin/*.php
chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/
chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/ admin/backups/
