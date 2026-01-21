#!/bin/bash

echo "Nginx: Waiting for WordPress files in /var/www/html..."
while [ ! -f /var/www/html/index.php ]; do
    sleep 2
done

echo "Nginx: WordPress is ready! Starting Nginx..."

exec nginx -g 'daemon off;'
