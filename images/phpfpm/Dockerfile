FROM php:8.0.9-fpm AS build-phpfpm-8.0.9

RUN apt-get update && apt-get install -y \
    wget \
    git \
    fish \
    libzip-dev \
    libicu-dev \
    zip \
    libfreetype6-dev \
    libmcrypt-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zlib1g-dev \
    g++ \
    libldap2-dev \
    libxml++2.6-dev \
    libpq-dev \
    libmagickwand-dev \
    libldap2-dev \
    unzip \
    libtidy-dev \
    librabbitmq-dev \
    libssh-dev \
    --no-install-recommends

# Add PECL
RUN pecl install \
    imagick \
    apcu \
    redis \
    amqp

# Add Extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/

RUN docker-php-ext-install \
    gd \
    intl \
    ldap \
    mysqli \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    shmop \
    soap \
    sockets \
    zip \
    bcmath \
    opcache \
    tidy

RUN docker-php-ext-enable \
    apcu \
    redis \
    imagick \
    amqp

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /var/www

ADD composer.json /var/www

RUN composer install

EXPOSE 9000

FROM build-phpfpm-8.0.9 AS build-phpfpm-xdebug-8.0.9

RUN pecl install \
    xdebug-3.0.4
RUN docker-php-ext-enable \
    xdebug

FROM build-phpfpm-8.0.9 AS build-phpfpm-wordpress-8.0.9
WORKDIR /var/www
# Symfony tool
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

FROM build-phpfpm-wordpress-8.0.9 AS build-phpfpm-wordpress-xdebug-8.0.9

RUN pecl install \
    xdebug-3.0.4
RUN docker-php-ext-enable \
    xdebug

FROM build-phpfpm-8.0.9 AS build-phpfpm-symfony-8.0.9
WORKDIR /var/www
# Symfony tool
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN apt-get update && apt-get install -y \
    graphviz \
    --no-install-recommends

FROM build-phpfpm-symfony-8.0.9 AS build-phpfpm-symfony-xdebug-8.0.9

RUN pecl install \
    xdebug-3.0.4
RUN docker-php-ext-enable \
    xdebug

FROM build-phpfpm-8.0.9 AS build-phpfpm-drupal-8.0.9
WORKDIR /var/www
# Symfony tool
RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar && chmod +x drush.phar && mv drush.phar /usr/local/bin/drush

FROM build-phpfpm-drupal-8.0.9 AS build-phpfpm-drupal-xdebug-8.0.9

RUN pecl install \
    xdebug-3.0.4
RUN docker-php-ext-enable \
    xdebug

FROM build-phpfpm-8.0.9 as build-phpfpm-all-8.0.9

RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN apt-get update && apt-get install -y \
    graphviz \
    --no-install-recommends

RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar && chmod +x drush.phar && mv drush.phar /usr/local/bin/drush

FROM build-phpfpm-all-8.0.9 AS build-phpfpm-all-xdebug-8.0.9

RUN pecl install \
    xdebug-3.0.4
RUN docker-php-ext-enable \
    xdebug
