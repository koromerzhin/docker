FROM VERSIONIMAGE AS build-php-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/download/2.7.6/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} appgroup && useradd -u ${UID} -g appgroup appuser

# Fixer les permissions
RUN chown -R appuser:appgroup /var/www

# Exécuter le conteneur en tant qu'utilisateur
USER appuser

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

WORKDIR /var/www

EXPOSE 9000

FROM build-php-apache AS build-php-apache-wordpress
# Wordpress
RUN wget https://github.com/wp-cli/wp-cli/releases/download/v2.10.0/wp-cli-2.10.0.phar -O wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


FROM build-php-apache AS build-php-apache-symfony
# Symfony
RUN wget https://github.com/symfony-cli/symfony-cli/releases/download/v5.10.5/symfony-cli_5.10.5_amd64.deb -O symfony-cli_amd64.deb && \
    dpkg -i symfony-cli_amd64.deb && \
    rm symfony-cli_amd64.deb


FROM build-php-apache AS build-php-apache-xdebug

RUN install-php-extensions xdebug

FROM build-php-apache-wordpress AS build-php-apache-wordpress-xdebug

RUN install-php-extensions xdebug

FROM build-php-apache-symfony AS build-php-apache-symfony-xdebug

RUN install-php-extensions xdebug
