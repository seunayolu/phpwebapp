#!/bin/bash

# Update the apt repository
sudo yum update -y

# EFS Utils Installation for Amazon Linux

# Create /var/www/html directory

sudo mkdir -p /var/www/html

# Variable for EFS

EFS_DNS_NAME=fs-0bc07e8d29a0b0eb4.efs.eu-west-1.amazonaws.com

# EFS Mount to the /var/www/html

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "$EFS_DNS_NAME":/ /var/www/html

# Install httpd

sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd

# Install apache and php dependencies for the php web app
sudo yum install php8.3 php8.3-mysqlnd composer git -y 

# Clone Source code from git

git clone -b contactform https://github.com/seunayolu/phpwebapp.git
# sudo rm -r /var/www/html/*.html
cd phpwebapp/app
sudo cp -r ./* /var/www/html/

# Update /var/www/html directory permission
# sudo chown www-data:www-data /var/www/html/*.php
sudo chmod 755 /var/www/html/*.*

# Install aws-sdk-php 

cd /var/www/html
sudo composer install -n
