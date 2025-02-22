FROM VERSIONIMAGE AS build-php-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/download/2.7.14/install-php-extensions /usr/local/bin/

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

FROM build-php-apache AS build-php-apache-wordpress
# Wordpress
RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar -O wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


FROM build-php-apache AS build-php-apache-symfony
# Symfony
RUN wget https://github.com/symfony-cli/symfony-cli/releases/download/v5.10.6/symfony-cli_5.10.6_amd64.deb -O symfony-cli_amd64.deb && \
    dpkg -i symfony-cli_amd64.deb && \
    rm symfony-cli_amd64.deb


FROM build-php-apache AS build-php-apache-xdebug

RUN install-php-extensions xdebug

FROM build-php-apache-wordpress AS build-php-apache-wordpress-xdebug

RUN install-php-extensions xdebug

FROM build-php-apache-symfony AS build-php-apache-symfony-xdebug

RUN install-php-extensions xdebug
