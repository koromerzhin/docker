FROM koromerzhin/phpfpm:8.0.9

RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN apt-get update && apt-get install -y graphviz --no-install-recommends

RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar && chmod +x drush.phar && mv drush.phar /usr/local/bin/drush
