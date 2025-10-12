FROM VERSIONIMAGE AS build-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/download/2.9.13/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

RUN a2enmod headers rewrite

ENV APACHE_DOCUMENT_ROOT /var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && \
    apt-get install -y wget git fish unzip zip graphviz --no-install-recommends && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

# Add Extension
RUN install-php-extensions \
    @composer \
    amqp \
    apcu \
    bcmath \
    blackfire \
    exif \
    gd \
    imagick \
    intl \
    ldap \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    redis \
    shmop \
    soap \
    sockets \
    tidy \
    zip \
    gnupg

WORKDIR /var/www

EXPOSE 9000

FROM build-apache AS build-apache-wordpress
# Wordpress
RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.12.0/wp-cli-2.12.0.phar -O wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


FROM build-apache AS build-apache-symfony
# Symfony
RUN wget https://github.com/symfony-cli/symfony-cli/releases/download/v5.15.1/symfony-cli_5.15.1_amd64.deb -O symfony-cli_amd64.deb && \
    dpkg -i symfony-cli_amd64.deb && \
    rm symfony-cli_amd64.deb


FROM build-apache AS build-apache-xdebug

RUN install-php-extensions xdebug

FROM build-apache-wordpress AS build-apache-wordpress-xdebug

RUN install-php-extensions xdebug

FROM build-apache-symfony AS build-apache-symfony-xdebug

RUN install-php-extensions xdebug
