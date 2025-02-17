#!/bin/sh

chown -R mysql:mysql /var/lib/mysql /run/mysqld

sleep 5

if [ ! -d "/var/lib/mysql/mysql/${DB_NAME}" ]; then
    echo "Initializing system database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal
fi

#if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then

cat << EOF > /tmp/db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
	mariadbd --user=mysql --bootstrap < /tmp/db.sql
	rm -f /tmp/db.sql
else
	echo "Database already exists"
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0