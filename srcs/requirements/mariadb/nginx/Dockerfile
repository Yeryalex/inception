FROM debian:12-slim

# Install Nginx and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/certs

# Generate Self-Signed SSL Certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/MyKey.key \
    -out /etc/nginx/certs/MyCert.crt \
    -subj "/C=ES/ST=Barcelona/L=Barcelona/O=42/OU=yrodrigu/CN=yrodrigu.42.fr"

# Copy your configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# --- NEW: INTEGRATE THE START SCRIPT ---
# Copy the script from your tools folder to the container
COPY tools/nginx_start.sh /usr/local/bin/nginx_start.sh

# Make sure the script is executable
RUN chmod +x /usr/local/bin/nginx_start.sh

# Create the web root directory and set permissions
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Expose port 443 only
EXPOSE 443

# --- CHANGE: Use the script as the ENTRYPOINT ---
# This ensures the waiting logic runs BEFORE Nginx starts
ENTRYPOINT ["/usr/local/bin/nginx_start.sh"]
