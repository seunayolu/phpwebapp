# Stage 1: Build Stage
# Use the official PHP 8.3 image with Apache for building the application
FROM php:8.3-cli AS builder

# Set working directory
WORKDIR /var/www/html

# Install git and other dependencies needed for Composer
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application files to the working directory
COPY app/ ./

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Stage 2: Final Stage
# Use the official PHP 8.3 image with Apache for the final image
FROM php:8.3-apache

# Set working directory
WORKDIR /var/www/html

# Install necessary extensions and Apache modules
RUN apt-get update && apt-get install -y \
    libpng-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && a2enmod rewrite \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy application files from the builder stage
COPY --from=builder /var/www/html /var/www/html

# Set the correct permissions for the web server
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]