FROM VERSIONIMAGE AS build-phpfpm

ADD https://github.com/mlocati/docker-php-extension-installer/releases/download/2.7.14/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

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


FROM build-phpfpm AS build-phpfpm-wordpress
# Wordpress
RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar -O wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


FROM build-phpfpm AS build-phpfpm-symfony
# Symfony
RUN wget https://github.com/symfony-cli/symfony-cli/releases/download/v5.10.6/symfony-cli_5.10.6_amd64.deb -O symfony-cli_amd64.deb && \
    dpkg -i symfony-cli_amd64.deb && \
    rm symfony-cli_amd64.deb


FROM build-phpfpm AS build-phpfpm-xdebug

RUN install-php-extensions xdebug


FROM build-phpfpm-wordpress AS build-phpfpm-wordpress-xdebug

RUN install-php-extensions xdebug


FROM build-phpfpm-symfony AS build-phpfpm-symfony-xdebug

RUN install-php-extensions xdebug
