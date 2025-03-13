# Use PHP 7.4 with Apache as base image
FROM php:7.4-apache

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy Laravel files into the container
COPY . .

# Install Laravel dependencies via Composer
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Expose port 80 for Apache
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
