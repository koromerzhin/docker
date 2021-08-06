FROM koromerzhin/phpfpm:8.0.9
WORKDIR /var/www
# Symfony tool
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN apt-get update && apt-get install -y graphviz --no-install-recommends