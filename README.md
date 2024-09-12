# PHP User Registration Application

This repository contains a simple PHP web application for user registration and generating a list of registered users. The application is hosted on AWS EC2 and uses RDS as the database. The application also includes functionality to download the list of registered users.

## Features

- User registration with name and email
- Generate a list of registered users
- Download the list of registered users as a CSV file
- Credentials stored securely using AWS Systems Manager Parameter Store

## Prerequisites

- AWS account
- EC2 instance running Ubuntu 24.04
- RDS instance
- PHP 8.3
- Composer

## Setup Instructions

### Step 1: Store Credentials in Parameter Store

1. Navigate to the Systems Manager console in AWS.
2. Choose Parameter Store from the left-hand menu.
3. Create a parameter for each piece of sensitive information:
   - `DB_HOST`
   - `DB_USERNAME`
   - `DB_PASSWORD`
   - `DB_NAME`
4. For each parameter:
   - Choose `Create parameter`.
   - Enter the name (e.g., `/myapp/DB_HOST`).
   - Select `Standard` or `Advanced` tier.
   - Select `SecureString` as the type.
   - Enter the value (e.g., your RDS endpoint for `DB_HOST`).
   - Set appropriate IAM permissions to control access to these parameters.
   - Repeat for each parameter.

### Step 2: Grant EC2 Instance Access to Parameter Store

1. Attach an IAM role to your EC2 instance with the following managed policy: `AmazonSSMReadOnlyAccess`.
2. Ensure the instance profile is attached to the EC2 instance and includes the necessary permissions to read the parameters.

### Step 3: Install AWS SDK for PHP on Ubuntu 24.04 with PHP 8.3

1. Update the package list and install necessary packages:
   ```bash
   sudo apt update
   sudo apt install apache2 php8.3 php8.3-cli php8.3-common php8.3-curl php8.3-xml php8.3-mbstring libapache2-mod-php php-mysql mysql-client -y
   ```

2. Install Composer (PHP dependency manager):
   ```bash
   sudo apt install composer -y
   ```

3. Install AWS SDK for PHP using Composer:
   ```bash
   cd /var/www/html
   composer require aws/aws-sdk-php -n
   ```

### Step 4: Create a Helper Script to Fetch Parameters

Create a `fetch_credentials.php` file that fetches credentials from AWS Systems Manager Parameter Store.

### Step 5: Update Your PHP Scripts

Update your PHP scripts (`index.php`, `register.php`, `list_users.php`, and `download_users.php`) to use the fetched credentials.

### Step 6: Connect to RDS Database 

Connect your RDS instance from your EC2 Instance using the following command:

```mysql
mysql -h your-rds-endpoint -u admin -pyourpassword database-name
```
Then copy and paste the sql command below to create your table

```sql

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

DESCRIBE users; # To check if the table was created successfully
```

### Step 7: Deployment

1. Upload new files to your EC2 instance.
   ```bash
   cd /var/www/html
   sudo nano fetch_credentials.php
   # Copy and paste the fetch_credentials.php code

   sudo nano index.php
   # Copy and paste the updated index.php code

   sudo nano list_users.php
   # Copy and paste the updated list_users.php code

   sudo nano download_users.php
   # Copy and paste the updated download_users.php code
   ```

2. Change file permissions:
   ```bash
   sudo chown www-data:www-data /var/www/html/*.php
   sudo chmod 755 /var/www/html/*.php
   ```

3. Restart Apache to ensure all changes are loaded:
   ```bash
   sudo systemctl restart apache2
   ```

4. Test your application in a web browser by navigating to the public IP of your EC2 instance.