FROM debian:12-slim

# Install PHP-FPM, PHP-MySQL, and helper tools
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set up PHP-FPM to listen on port 9000 instead of a socket
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

# Create the folder for the PHP process to run
RUN mkdir -p /run/php

# Install WP-CLI (The command line tool for WordPress)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set the working directory
WORKDIR /var/www/html

# Copy and prepare the setup script
COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Entrypoint runs our script, CMD runs the actual PHP process
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["php-fpm8.2", "-F"]
