FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration and initialization files
#COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY tools/docker-entrypoint.sh /usr/local/bin/

# Set proper permissions and create necessary directories
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    mkdir -p /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql && \
    chmod 777 /var/run/mysqld

    

EXPOSE 3306

USER mysql

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
