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
composer \
php-mysql \
mysql-client

# Variable for EFS

EFS_DNS_NAME=fs-0bc07e8d29a0b0eb4.efs.eu-west-1.amazonaws.com

# EFS Mount to the /var/www/html

echo "$EFS_DNS_NAME:/ /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mount -a

# Update /var/www/html directory permission
sudo chown www-data:www-data /var/www/html/*
sudo chmod 755 /var/www/html/*
cd ~
