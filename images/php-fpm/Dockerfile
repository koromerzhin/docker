FROM php:7.4-fpm

RUN apt-get update && apt-get install -y wget git fish

# UPDATE
RUN apt-get update

# Add Lib
RUN apt-get install -y libzip-dev libicu-dev

# Support de Postgre
RUN apt-get install -y libpq-dev

# Imagick
RUN apt-get install -y libmagickwand-dev --no-install-recommends

# Add PECL
RUN pecl install imagick
RUN pecl install apcu
RUN pecl install redis
RUN pecl install xdebug-2.9.7

# Add Extension
RUN docker-php-ext-enable apcu
RUN docker-php-ext-enable redis
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo zip intl opcache
RUN docker-php-ext-install mysqli pdo_mysql
RUN docker-php-ext-enable imagick
RUN docker-php-ext-enable xdebug

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /var/www

EXPOSE 9000