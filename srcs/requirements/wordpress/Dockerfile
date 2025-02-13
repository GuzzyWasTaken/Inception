# Use Alpine Linux with PHP-FPM
FROM php:8.1-fpm-alpine

# Set environment variables
ENV WORDPRESS_DB_HOST=mariadb
ENV WORDPRESS_DB_USER=${DB_USER}
ENV WORDPRESS_DB_PASSWORD=${DB_PASS}
ENV WORDPRESS_DB_NAME=${DB_NAME}

# Install required dependencies
RUN apk add --no-cache \
    bash \
    curl \
    mariadb-client \
    zlib-dev \
    libzip-dev \
    && docker-php-ext-install zip pdo_mysql

# Download and install WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    mkdir -p /var/www/html/wordpress && \
    cd /var/www/html/wordpress && \
    wp core download --allow-root && \
    wp config create --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_DB_USER} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=${WORDPRESS_DB_HOST} --allow-root && \
    wp core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --skip-email --allow-root && \
    wp user create ${WP_USER_NAME} ${WP_USER_EMAIL} --role=${WP_USER_ROLE} --user_pass=${WP_USER_PASS} --allow-root

# Expose port 9000 for PHP-FPM
EXPOSE 433

# Start PHP-FPM
CMD ["php-fpm"]