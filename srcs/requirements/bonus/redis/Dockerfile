FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends redis-server \
	&& rm -rf /var/lib/apt/lists/*

COPY tools/redis_init.sh /usr/local/bin/redis_init.sh
COPY tools/redis_healthcheck.sh /usr/local/bin/redis_healthcheck.sh

RUN chmod +x /usr/local/bin/redis_init.sh /usr/local/bin/redis_healthcheck.sh

EXPOSE 6379

ENTRYPOINT ["/usr/local/bin/redis_init.sh"]
