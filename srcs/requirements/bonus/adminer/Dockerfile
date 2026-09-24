FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
	php-cli \
	php-mysql \
	php-mbstring \
	php-xml \
	wget \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget -O index.php https://www.adminer.org/latest-mysql.php

COPY tools/adminer_init.sh /usr/local/bin/adminer_init.sh

RUN chmod +x /usr/local/bin/adminer_init.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/adminer_init.sh"]
