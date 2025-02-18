#!/bin/bash

# Create necessary directories and set permissions
mkdir -p /var/www/html/wordpress
touch /run/php/php8.2-fpm.pid
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# Download/Install WordPress if not already present
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    cd /var/www/html/wordpress

    # Download WordPress
    echo "Downloading WordPress..."
    wp core download \
        --path="/var/www/html/wordpress/" \
        --allow-root
    echo "WordPress downloaded."

    # Wait for MariaDB to be ready
    echo "Waiting for MariaDB to connect..."
    until mysqladmin -h${WP_DATABASE_HOST} -u${DB_USER} -p${DB_USER_PASSWORD} ping; do
        sleep 2
    done

    # Create wp-config.php
    echo "Creating WordPress Configuration..."
    wp config create \
        --path="/var/www/html/wordpress/" \
        --dbname="${WP_DATABASE_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_USER_PASSWORD}" \
        --dbhost="${WP_DATABASE_HOST}" \
        --allow-root

    # Install WordPress
    echo "Creating WordPress Admin..."
    wp core install \
        --path="/var/www/html/wordpress/" \
        --url="${DOMAIN_NAME}" \
        --title="inception" \
        --admin_user="${WP_ADMIN}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    # Create WordPress User
    echo "Creating WordPress User..."
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --path="/var/www/html/wordpress/" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor \
        --allow-root

    echo "WordPress setup complete."
else
    echo "WordPress is already downloaded and setup."
fi

# Start PHP-FPM in the foreground
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F