#!/bin/bash
set -eu

if [ ! -f /etc/nginx/ssl/inception.crt ] || [ ! -f /etc/nginx/ssl/inception.key ]; then
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/ssl/inception.key \
		-out /etc/nginx/ssl/inception.crt \
		-subj "/C=CZ/ST=Prague/L=Prague/O=42/CN=${DOMAIN_NAME}" \
		-addext "subjectAltName=DNS:${DOMAIN_NAME},DNS:static.${DOMAIN_NAME}"
fi

envsubst '${DOMAIN_NAME}' \
	< /etc/nginx/nginx.conf \
	> /tmp/nginx.conf

mv /tmp/nginx.conf /etc/nginx/nginx.conf

exec "$@"
