#!/bin/bash
set -e

if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "MariaDB: First run detected. Initializing database..."

    chown -R mysql:mysql /var/lib/mysql

    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm > /dev/null

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

# Delete the default 'anyone can login' users
DELETE FROM mysql.user WHERE User='';
# Disable remote root login (security best practice)
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

# Set the Root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

# Create the WordPress database and user
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    echo "MariaDB: Running setup commands..."
    /usr/sbin/mysqld --user=mysql --bootstrap < $tfile
    
    rm -f $tfile

    echo "MariaDB: Setup finished successfully."
else
    echo "MariaDB: Data directory already exists. Skipping initialization."
fi

echo "MariaDB: Starting daemon..."

exec "$@"
