#!/bin/bash
set -e

# 1. Read secrets into local variables
# These files are mounted by Docker Compose in /run/secrets/
if [ -f /run/secrets/db_password ]; then
    MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f /run/secrets/db_root_password ]; then
    MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

# 2. Check if the database is already initialized
# We check for the 'mysql' system folder. If it doesn't exist, we must init.
if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "MariaDB: First run detected. Initializing database..."

    # Ensure the correct ownership of the data directory
    chown -R mysql:mysql /var/lib/mysql

    # Initialize the system tables
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm > /dev/null

    # 3. Create a temporary SQL file to set up users and passwords
    # This is the most secure way to pass passwords to MariaDB
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

    # 4. Run the MariaDB daemon in "bootstrap" mode
    # This executes the SQL commands in $tfile and then exits immediately
    echo "MariaDB: Running setup commands..."
    /usr/sbin/mysqld --user=mysql --bootstrap < $tfile
    
    # Remove the temporary file with the clear-text passwords
    rm -f $tfile

    echo "MariaDB: Setup finished successfully."
else
    echo "MariaDB: Data directory already exists. Skipping initialization."
fi

# 5. Hand over to the main MariaDB process
# 'exec' replaces the shell with the mysqld process as PID 1
echo "MariaDB: Starting daemon..."
exec "$@"
