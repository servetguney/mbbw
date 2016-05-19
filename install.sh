#!/bin/bash

#
# MyBB AMI installation script invoked by AWS CloudFormation template.
# (C) Valeriu Paloş <valeriupalos@gmail.com>
#
# Apache2, Php5x and required dependencies for MyBB are expected to be
# properly added to the system by this point.
#

# Configuration.
CONFIGFILE="./createdconfig.php"
DATASOURCE="./mybbdump.sql"
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
# 7. EMAIL

MYBB_DOMAINNAME="${1}"
MYBB_DBNAME="${2}"
MYBB_DBPORT="${3}"
MYBB_DBHOSTNAME="${4}"
MYBB_DBUSERNAME="${5}"
MYBB_DBPASSWORD="${6}"
MYBB_EMAIL="${7}"





# Prepare and copy dynamic configuration files.
sed -e "s/MYBB_ADMINEMAIL/${MYBB_EMAIL}/g" \
    -e "s/MYBB_DOMAINNAME/${MYBB_DOMAINNAME}/g" \
    "${CONFIG}/settings.php" > "${TARGET}/inc/settings.php"

sed -e "s/MYBB_DBNAME/${MYBB_DBNAME}/g" \
    -e "s/MYBB_DBUSERNAME/${MYBB_DBUSERNAME}/g" \
    -e "s/MYBB_DBPASSWORD/${MYBB_DBPASSWORD}/g" \
    -e "s/MYBB_DBHOSTNAME/${MYBB_DBHOSTNAME}/g" \
    -e "s/MYBB_DBPORT/${MYBB_DBPORT}/g" \
    "${CONFIG}/config.php" > "${TARGET}/inc/config.php"

# Initialize database.
sed -e "s/MYBB_ADMINEMAIL/${MYBB_ADMINEMAIL}/g" \
    -e "s/MYBB_DOMAINNAME/${MYBB_DOMAINNAME}/g" \
    "${CONFIG}/mybb.sql" | mysql \
    --user="$MYBB_DBUSERNAME" \
    --password="$MYBB_DBPASSWORD" \
    --host="$MYBB_DBHOSTNAME" \
    --port="$MYBB_DBPORT" \
    --database="$MYBB_DBNAME" || echo "WE ASSUME DATA ALREADY EXISTS!"

# Set proper ownership and permissions.
cd "$TARGET"
# chown www-data:www-data *
chmod 666 inc/config.php inc/settings.php
chmod 666 inc/languages/english/*.php inc/languages/english/admin/*.php

# TODO: The "uploads/" path should be mounted on an S3 bucket.
chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/
chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/ admin/backups/
