FROM alpine:3.19

RUN apk update && apk upgrade && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql

RUN sed -i "s|skip-networking|#skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db

COPY ./tools/config.sh /config.sh
COPY ./conf/50-server.cnf /50-server.cnf
RUN chmod +x /50-server.cnf
RUN chmod +x /config.sh

EXPOSE 3306

ENTRYPOINT ["/config.sh"]
