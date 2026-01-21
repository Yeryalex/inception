FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/certs

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/MyKey.key \
    -out /etc/nginx/certs/MyCert.crt \
    -subj "/C=ES/ST=Barcelona/L=Barcelona/O=42/OU=yrodrigu/CN=yrodrigu.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/nginx_start.sh /usr/local/bin/nginx_start.sh

RUN chmod +x /usr/local/bin/nginx_start.sh

RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/nginx_start.sh"]
