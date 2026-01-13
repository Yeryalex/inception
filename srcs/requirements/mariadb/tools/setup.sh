#!/bin/bash

# Check if the database already exists to avoid re-initializing
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then

    echo "Initializing MariaDB database..."

    # 1. Initialize the system tables
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # 2. Start a temporary instance to run setup commands
    # We use a temporary SQL file to secure the installation
    tfile=`mktemp`
    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

# Set root password and delete anonymous users
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

# Create the WordPress database and user
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;
EOF

    # 3. Use bootstrap mode to run our initialization SQL
    # This is the "clean" way to set up without running a full server yet
    mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile

    echo "MariaDB setup finished!"
fi

# Hand over to the main process (mysqld)
exec "$@"
