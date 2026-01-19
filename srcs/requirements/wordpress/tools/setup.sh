#!/bin/bash
set -e

# 1. Read secrets into variables
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# 2. Wait for MariaDB to be ready
echo "WordPress: Waiting for MariaDB..."
while ! mariadb-admin ping -h"mariadb" --silent; do
    sleep 1
done

# 3. Installation logic
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress: Core files not found. Starting installation..."

    # MANDATORY: Download the WordPress source code first
    wp core download --path='/var/www/html' --allow-root

    # Create wp-config.php using the DB secrets
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --path='/var/www/html' \
        --allow-root

    # Run the installation
    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/html' \
        --allow-root

    # Create the second user (Author)
    wp user create \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --path='/var/www/html' \
        --allow-root

    echo "WordPress: Setup finished!"
else
    echo "WordPress: Already installed, skipping to start PHP-FPM."
fi

# 4. Final permissions fix to allow Nginx to read the files
chown -R www-data:www-data /var/www/html

# 5. Hand over to CMD (php-fpm8.2 -F)
exec "$@"
