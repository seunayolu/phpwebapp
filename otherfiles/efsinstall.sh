#!/bin/bash

# Update the apt repository
sudo apt update -y

# EFS Utils Installation for Ubuntu 24.04

sudo apt -y install git binutils rustc cargo pkg-config libssl-dev
git clone https://github.com/aws/efs-utils
cd efs-utils
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb
cd ~

# Create /var/www/html directory

sudo mkdir -p /var/www/html

# Variable for EFS

EFS_DNS_NAME=fs-0bc07e8d29a0b0eb4.efs.eu-west-1.amazonaws.com

# EFS Mount to the /var/www/html

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "$EFS_DNS_NAME":/ /var/www/html

# Install apache2

sudo apt install apache2 -y

# Install apache and php dependencies for the php web app
sudo apt install -y \
php8.3 \
php8.3-cli \
php8.3-common \
php8.3-curl \
php8.3-xml \
php8.3-mbstring \
libapache2-mod-php \
php-mysql \
composer \
git \
mysql-client

# Clone Source code from git

git clone -b contactform https://github.com/seunayolu/phpwebapp.git
sudo rm -r /var/www/html/*.html
cd phpwebapp/app
sudo cp -r ./* /var/www/html/

# Update /var/www/html directory permission
sudo chown www-data:www-data /var/www/html/*.php
sudo chmod 755 /var/www/html/*.php

# Install aws-sdk-php 

cd /var/www/html
sudo composer install -n
