FROM php:7.4-fpm

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y git
RUN apt-get install -y fish
RUN apt-get install -y libzip-dev
RUN apt-get install -y libicu-dev
RUN apt-get install -y zip
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libmcrypt-dev
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y libjpeg62-turbo-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y g++
RUN apt-get install -y libldap2-dev
RUN apt-get install -y libxml++2.6-dev
RUN apt-get install -y libpq-dev
RUN apt-get install -y libmagickwand-dev --no-install-recommends
RUN apt-get install -y libldap2-dev

# Add PECL
RUN pecl install imagick
RUN pecl install apcu
RUN pecl install redis
RUN pecl install xdebug-2.9.7

# Add Extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/

RUN docker-php-ext-install gd
RUN docker-php-ext-install intl
RUN docker-php-ext-install ldap
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install shmop
RUN docker-php-ext-install soap
RUN docker-php-ext-install sockets
RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-install zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install opcache

RUN docker-php-ext-enable apcu
RUN docker-php-ext-enable redis
RUN docker-php-ext-enable imagick
RUN docker-php-ext-enable xdebug

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /var/www

EXPOSE 9000