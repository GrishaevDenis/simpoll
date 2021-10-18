#!/bin/sh
set -e

sed -i "1s/.*/$HOSTNAME/" /etc/caddy/Caddyfile

DB_NAME="${DB_NAME:-simpoll}"
DB_USER="${DB_USER:-simpoll}"
DB_PASSWORD="${DB_PASSWORD:-simpoll}"

chown -R www-data /var/www/html && chgrp -R www-data /var/www/html

cron && /etc/init.d/mysql start && php-fpm -D
mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}; 
          CREATE USER IF NOT EXISTS '${DB_USER}' IDENTIFIED BY '${DB_PASSWORD}'; 
          GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}';
"

[ "$1" = '' ] && { caddy run --config /etc/caddy/Caddyfile;  }

exec "$@"
