FROM debian:12-slim

# Install the MariaDB server
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Create the directory for the MySQL socket and set permissions
# This is where the database process stores its temporary run files
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Copy our configuration and setup script
COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Open the standard MySQL port
EXPOSE 3306

# Start our script
ENTRYPOINT ["setup.sh"]
