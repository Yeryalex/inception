FROM debian:12-slim

# Install PHP-FPM, PHP-MySQL (for DB connection), and curl/mariadb-client
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set up PHP-FPM to listen on port 9000 (instead of a socket)
# This allows Nginx to communicate with it over the network
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

# Install WP-CLI (Command line tool for WordPress)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Create the folder for the PHP process to run
RUN mkdir -p /run/php

# Copy the setup script
COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Set the working directory to where WordPress files will live
WORKDIR /var/www/html

# Use the setup script as the entrypoint
ENTRYPOINT ["/usr/local/bin/setup.sh"]

# The default command is to start PHP-FPM in the foreground
CMD ["/usr/sbin/php-fpm8.2", "-F"]
