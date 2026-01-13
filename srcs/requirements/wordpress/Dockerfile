FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    && rm -rf /var/lib/apt/lists/*

# IMPORTANT: By default, PHP-FPM listens on a local file (socket).
# We must change it to listen on Port 9000 so Nginx can "call" it.
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

# Create the directory for PHP to run
RUN mkdir -p /run/php

# --- STEP 4 START ---
# Copy the test file from your host to the container's web root
COPY ./tools/test.php /var/www/html/test.php
# --- STEP 4 END ---

WORKDIR /var/www/html

# Start PHP-FPM in the foreground (-F)
CMD ["/usr/sbin/php-fpm8.2", "-F"]
