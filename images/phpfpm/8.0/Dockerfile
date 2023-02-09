FROM VERSIONIMAGE AS build-phpfpm

ADD https://github.com/mlocati/docker-php-extension-installer/releases/download/2.0.2/install-php-extensions /usr/local/bin/

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
    zip

# Wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
# Symfony
RUN wget https://github.com/symfony-cli/symfony-cli/releases/download/v5.4.21/symfony-cli_5.4.21_amd64.deb && \
    dpkg -i symfony-cli_5.4.21_amd64.deb && \
    rm symfony-cli_5.4.21_amd64.deb

WORKDIR /var/www


FROM build-phpfpm AS build-phpfpm-xdebug

RUN install-php-extensions xdebug
