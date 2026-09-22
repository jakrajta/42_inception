FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*   

COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/mariadb.cnf

COPY tools/init_db.sh /usr/local/bin/init_db.sh
COPY tools/healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /usr/local/bin/init_db.sh /usr/local/bin/healthcheck.sh

ENTRYPOINT ["/usr/local/bin/init_db.sh"]

CMD ["mariadbd", "--user=mysql"]
