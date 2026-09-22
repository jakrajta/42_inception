FROM debian:bookworm

RUN apt-get update &&  apt-get install -y --no-install-recommends \
	nginx \
	openssl \
	ca-certificates \
	gettext-base \
	curl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/init_nginx.sh /usr/local/bin/init_nginx.sh
COPY tools/nginx_healthcheck.sh /usr/local/bin/nginx_healthcheck.sh

RUN chmod +x /usr/local/bin/init_nginx.sh  /usr/local/bin/nginx_healthcheck.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init_nginx.sh"]
CMD ["nginx", "-g", "daemon off;"]



