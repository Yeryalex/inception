FROM debian:12-slim

# Install Nginx and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/certs

# Generate Self-Signed SSL Certificate
# -nodes: No password on the key
# -subj: Sets the certificate info automatically (Required for 42)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/MyKey.key \
    -out /etc/nginx/certs/MyCert.crt \
    -subj "/C=ES/ST=Barcelona/L=Barcelona/O=42/OU=yrodrigu/CN=yrodrigu.42.fr"

# Copy your configuration file into the container
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create the web root directory and set permissions
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Expose port 443 only (Inception rule)
EXPOSE 443

# Start Nginx in the foreground so the container doesn't close
CMD ["nginx", "-g", "daemon off;"]
