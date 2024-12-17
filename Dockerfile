FROM php:8.3-fpm

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpq-dev \
    libonig-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip\
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_pgsql \
    && docker-php-ext-install zip \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl

# Set the working directory inside the container
WORKDIR /var/www

# Copy the Laravel application files into the container
COPY . /var/www

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Laravel dependencies
RUN composer install

RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www
