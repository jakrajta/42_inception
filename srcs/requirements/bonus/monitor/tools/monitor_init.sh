#!/bin/bash

GREEN='\033[38;5;107m'
ORANGE='\033[38;5;209m'
R='\033[0m'


set -eu

while sleep 30; do
	if curl -k -fsS --max-time 5 -H "Host: ${DOMAIN_NAME}" https://nginx/ > /dev/null; then
		echo -e "${GREEN}[MONITOR] WordPress is UP${R}"
	else
		echo -e "${ORANGE}[MONITOR] WordPress is DOWN${R}"
	fi
done
