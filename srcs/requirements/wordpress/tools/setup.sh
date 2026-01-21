#!/bin/bash
set -e

# 1. Variables from secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# 2. WAIT for MariaDB (Crucial)
# Use nc to make sure the port is actually open
echo "WordPress: Waiting for MariaDB..."
while ! (echo > /dev/tcp/mariadb/3306) 2>/dev/null; do
    sleep 2
done

# 3. CHECK if WordPress is already there
# Only download if wp-settings.php (a core file) is missing
if [ ! -f "/var/www/html/wp-settings.php" ]; then
    echo "WordPress: Empty volume detected. Downloading core..."
    wp core download --path='/var/www/html' --allow-root
    
    # Create config
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root
        #--path='/var/www/html' \
        
    # Install
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

# 4. FINAL PERMISSIONS
# This ensures Nginx can read what WordPress wrote
chown -R www-data:www-data /var/www/html

exec "$@"
