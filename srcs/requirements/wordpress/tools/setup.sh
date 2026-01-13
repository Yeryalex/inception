#!/bin/bash

# 1. Wait for MariaDB to be ready
# We use the service name 'mariadb' defined in docker-compose
while ! mariadb-admin ping -h"mariadb" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# 2. Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."

    # Download WordPress core
    wp core download --allow-root

    # Create wp-config.php using .env variables
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root

    # Install the site (Set the admin user and regular user)
    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    # Create a simple second user (as required by some 42 subjects)
    wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author --allow-root
    
    echo "WordPress installation finished!"
fi

# 3. Hand over to the CMD (php-fpm8.2 -F)
exec "$@"
