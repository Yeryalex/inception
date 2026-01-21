FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

RUN rm -rf /var/lib/mysql/*

ENTRYPOINT ["/usr/local/bin/setup.sh"]

CMD ["mysqld", "--user=mysql", "--bind-address=0.0.0.0"]
