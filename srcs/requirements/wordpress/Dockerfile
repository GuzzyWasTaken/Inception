# Use Debian as a base image (Debian 12)
FROM debian:bullseye

# Set environment variables using ENV (NEED THIS: Because variables are NOT passed at Runtime)


# Update & intstall your package manager
RUN apt-get update -y && \
    apt-get -y install apt-utils php7.4 php-fpm php-mysql mariadb-client wget curl

# Create necessary directories
RUN  mkdir -p /run/php

# Copy custom WordPress configuration from 'tools' into 'pool.d' directory.
# Copy custom WordPress script from 'tools' directory into the container’s root directory (/).
COPY /tools/www.conf /etc/php/7.4/fpm/pool.d
COPY tools/wp-script.sh /

# Set permissions for the script -> Make sure the custom script is executable
RUN chmod +x /wp-script.sh

# This is the port that NGINX will use to communicate with WordPress (via PHP-FPM).
EXPOSE 9000

# Start PHP-FPM
CMD ["/wp-script.sh"]