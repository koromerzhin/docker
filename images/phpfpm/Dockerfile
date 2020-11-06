FROM php:7.4.12-fpm

RUN apt-get update && apt-get install -y wget --no-install-recommends
RUN apt-get install -y git --no-install-recommends
RUN apt-get install -y fish --no-install-recommends
RUN apt-get install -y libzip-dev --no-install-recommends
RUN apt-get install -y libicu-dev --no-install-recommends
RUN apt-get install -y zip --no-install-recommends
RUN apt-get install -y libfreetype6-dev --no-install-recommends
RUN apt-get install -y libmcrypt-dev --no-install-recommends
RUN apt-get install -y libjpeg-dev --no-install-recommends
RUN apt-get install -y libjpeg62-turbo-dev --no-install-recommends
RUN apt-get install -y libpng-dev --no-install-recommends
RUN apt-get install -y zlib1g-dev --no-install-recommends
RUN apt-get install -y g++ --no-install-recommends
RUN apt-get install -y libldap2-dev --no-install-recommends
RUN apt-get install -y libxml++2.6-dev --no-install-recommends
RUN apt-get install -y libpq-dev --no-install-recommends
RUN apt-get install -y libmagickwand-dev --no-install-recommends
RUN apt-get install -y libldap2-dev --no-install-recommends
RUN apt-get install -y unzip --no-install-recommends

# Add PECL
RUN pecl install imagick
RUN pecl install apcu
RUN pecl install redis

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

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /var/www

EXPOSE 9000