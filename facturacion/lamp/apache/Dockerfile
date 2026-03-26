FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libzip-dev unzip \
    && docker-php-ext-install pdo pdo_mysql mysqli zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN a2enmod rewrite headers

