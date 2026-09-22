#!/bin/sh

mariadb-admin \
    --user=root \
    --password="$(cat /run/secrets/db_root_password)" \
    ping >/dev/null 2>&1
