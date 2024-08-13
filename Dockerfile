# Use the official PHP 8.3 image as a base
FROM php:8.3-apache

# Install necessary extensions, Apache mod_rewrite, and Composer
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip curl && \
    docker-php-ext-install mysqli && \
    docker-php-ext-enable mysqli && \
    a2enmod rewrite && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy application files to the container
COPY . .

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html && \
    composer require aws/aws-sdk-php

# Expose port 80
EXPOSE 80