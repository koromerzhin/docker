FROM VERSIONIMAGE AS build-fpm

ADD PHPEXTENSIONS /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

RUN apt-get update && \
    apt-get install -y wget git fish unzip zip graphviz --no-install-recommends && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

# Add Extension
RUN install-php-extensions PHPLISTEXTENSION

WORKDIR /var/www


FROM build-fpm AS build-fpm-wordpress
# Wordpress
RUN wget WORDPRESSPHAR -O wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


FROM build-fpm AS build-fpm-symfony
# Symfony
RUN wget SYMFONYCLI -O symfony-cli_amd64.deb && \
    dpkg -i symfony-cli_amd64.deb && \
    rm symfony-cli_amd64.deb


FROM build-fpm AS build-fpm-xdebug

RUN install-php-extensions xdebug


FROM build-fpm-wordpress AS build-fpm-wordpress-xdebug

RUN install-php-extensions xdebug


FROM build-fpm-symfony AS build-fpm-symfony-xdebug

RUN install-php-extensions xdebug
