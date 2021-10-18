FROM php:5.6.40-fpm

ENV TZ=Europe/Moscow
#ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y tzdata \
        libfreetype6-dev libjpeg62-turbo-dev libpng-dev libtidy-dev libtidy5 \
        mysql-server cron \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli mysql tidy

RUN mkdir /usr/local/ioncube \ 
    && cd /usr/local \
    && curl -sL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz  | tar -xzv \
    && echo zend_extension = /usr/local/ioncube/ioncube_loader_lin_5.6.so > /usr/local/etc/php/conf.d/ioncube_loader.ini

RUN apt install -y debian-keyring debian-archive-keyring apt-transport-https \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt update \
    && apt install caddy \
    && apt-get autoremove -y --purge \
    && rm -rf /var/lib/apt/lists/*

RUN echo date.timezone = Europe/Moscow >> /usr/local/etc/php/php.ini
RUN echo mysql.default_socket = /var/run/mysqld/mysqld.sock >> /usr/local/etc/php/php.ini
RUN echo mysqli.default_socket = /var/run/mysqld/mysqld.sock >> /usr/local/etc/php/php.ini
RUN echo socket = /var/run/mysqld/mysqld.sock >> /etc/mysql/my.cnf

ADD entrypoint.sh /entrypoint.sh
ADD crontab /etc/crontab
ADD Caddyfile /etc/caddy/Caddyfile

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

