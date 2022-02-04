FROM php:8.1.2-fpm AS build-phpfpm-8.1.2

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

RUN apt-get update && apt-get install -y wget git fish unzip zip --no-install-recommends

# Add Extension
RUN install-php-extensions amqp apcu bcmath blackfire @composer gd imagick intl ldap mysqli opcache pdo_mysql pdo_pgsql redis shmop soap sockets tidy zip

# Wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
# Symfony
RUN wget https://github.com/symfony-cli/symfony-cli/releases/download/v5.2.2/symfony-cli_5.2.2_amd64.deb && dpkg -i symfony-cli_5.2.2_amd64.deb && rm symfony-cli_5.2.2_amd64.deb

RUN apt-get update && apt-get install -y \
    graphviz \
    --no-install-recommends

WORKDIR /var/www

ADD composer.json /var/www

RUN composer install

EXPOSE 9000

FROM build-phpfpm-8.1.2 AS build-phpfpm-xdebug-8.1.2

RUN install-php-extensions xdebug