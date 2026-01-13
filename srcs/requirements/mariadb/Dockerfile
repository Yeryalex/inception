FROM debian:12-slim

# Install MariaDB server
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Create the directory for the mysql socket and set permissions
# In Debian, the service needs this to start correctly
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Copy the configuration script
COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Expose the default MariaDB port
EXPOSE 3306

# Start with our setup script
ENTRYPOINT ["/usr/local/bin/setup.sh"]

# The default command to run the server in the foreground
CMD ["mysqld", "--user=mysql", "--bind-address=0.0.0.0"]
