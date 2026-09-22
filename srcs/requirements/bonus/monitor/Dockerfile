FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
	curl \
	&& rm -rf  /var/lib/apt/lists/*

COPY tools/monitor_init.sh /usr/local/bin/monitor_init.sh

RUN chmod +x /usr/local/bin/monitor_init.sh

ENTRYPOINT ["/usr/local/bin/monitor_init.sh"]