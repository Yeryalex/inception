#!/bin/bash

# Wait for WordPress to create index.php
echo "Nginx: Waiting for WordPress files in /var/www/html..."
while [ ! -f /var/www/html/index.php ]; do
    sleep 2
done

echo "Nginx: WordPress is ready! Starting Nginx..."

# This replaces the shell process with Nginx
exec nginx -g 'daemon off;'
