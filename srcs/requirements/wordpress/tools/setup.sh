#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

echo "WordPress: Waiting for MariaDB..."
while ! (echo > /dev/tcp/mariadb/3306) 2>/dev/null; do
    sleep 2
done

if [ ! -f "/var/www/html/wp-settings.php" ]; then
    echo "WordPress: Empty volume detected. Downloading core..."
    wp core download --path='/var/www/html' --allow-root
    
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root
       # --path='/var/www/html' \
        
    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/html' \
        --allow-root

    wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author --path='/var/www/html' --allow-root
else
    echo "WordPress: Files detected. Skipping download."
fi

chown -R www-data:www-data /var/www/html

exec "$@"
