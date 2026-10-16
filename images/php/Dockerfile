ARG SERVER=apache
FROM VERSIONIMAGE AS build-base

ARG SERVER

ADD PHPEXTENSIONS /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

# Apache uniquement (a2enmod n'existe pas sur les images fpm)
RUN if [ "$SERVER" = "apache" ]; then a2enmod headers rewrite; fi

RUN apt-get update && apt-get autoremove
RUN apt-get install -y PKGINSTALL --no-install-recommends
RUN apt-get clean && rm -fr /var/lib/apt/lists/*

# Add Extension
RUN install-php-extensions PHPLISTEXTENSION

WORKDIR /var/www

# Apache sert HTTP sur 80, php-fpm écoute FastCGI sur 9000 (substitué à la génération).
EXPOSE EXPOSEPORT

# Contrôle minimal : l'interpréteur répond. Surcharger au déploiement (ex. wget sur vhost).
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD php -v || exit 1


FROM build-base AS build-wordpress
# Wordpress
RUN wget WORDPRESSPHAR -O wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp


FROM build-base AS build-symfony
# Symfony (paquet .deb amd64 uniquement : variantes symfony non supportées sur arm64)
RUN wget SYMFONYCLI -O symfony-cli_amd64.deb && dpkg -i symfony-cli_amd64.deb && rm symfony-cli_amd64.deb


FROM build-base AS build-xdebug

RUN install-php-extensions xdebug


FROM build-wordpress AS build-wordpress-xdebug

RUN install-php-extensions xdebug


FROM build-symfony AS build-symfony-xdebug

RUN install-php-extensions xdebug
