FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	php-fpm \
	php-gd \
	php-mbstring \
	php-mysql \
	php-xml \
	php-zip \
	openssl \
	tar \
	unzip \
	wget \
	procps \
	gettext-base \
	php-redis \
	netcat-openbsd \
	&& rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/wordpress.tar.gz \
        https://wordpress.org/wordpress-7.1.tar.gz \
    && mkdir -p /tmp/wordpress /usr/local/share/wordpress \
    && tar -xzf /tmp/wordpress.tar.gz -C /tmp/wordpress \
    && cp -a /tmp/wordpress/wordpress/. /usr/local/share/wordpress/ \
    && rm -rf /tmp/wordpress /tmp/wordpress.tar.gz
	
RUN wget -O /usr/local/bin/wp \
        https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

RUN wget -O /tmp/redis-cache.zip \
        https://downloads.wordpress.org/plugin/redis-cache.zip \
    && mkdir -p /usr/local/share/wordpress/wp-content/plugins \
    && unzip /tmp/redis-cache.zip \
        -d /usr/local/share/wordpress/wp-content/plugins \
    && rm /tmp/redis-cache.zip

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/init_wp.sh /usr/local/bin/init_wp.sh
COPY conf/wp-config.php /usr/local/share/wordpress/wp-config.php.template

COPY tools/wp_healthcheck.sh /usr/local/bin/wp_healthcheck.sh

RUN chmod +x /usr/local/bin/init_wp.sh /usr/local/bin/wp_healthcheck.sh

ENTRYPOINT ["/usr/local/bin/init_wp.sh"]
CMD ["php-fpm8.2", "-F"]
