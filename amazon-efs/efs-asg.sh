#!/bin/bash

# Update the apt repository
sudo yum update -y

# Install httpd on Amazon Linux 2023

sudo yum install git httpd -y

# Install apache and php dependencies for the php web app
sudo amazon-linux-extras enable php8.3
sudo yum install -y \
php-cli \
php-common \
php-curl \
php-xml \
php-mbstring \
php-mysqlnd \
php-json 

# Variable for EFS

EFS_DNS_NAME=fs-0a6b29d643e23c629.efs.eu-west-2.amazonaws.com

# EFS Mount to the /var/www/html

echo "$EFS_DNS_NAME:/ /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount -a

# Update /var/www/html directory permission
sudo chown www-data:www-data /var/www/html/*.php
sudo chmod 755 /var/www/html/*.php
cd ~

# PHP Dependency to connect to AWS Parameter Store
sudo yum install composer -y