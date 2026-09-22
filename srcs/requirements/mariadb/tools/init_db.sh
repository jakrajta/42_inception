#!/bin/sh

set -eu

DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
DB_USER_PASSWORD="$(cat /run/secrets/db_user_password)"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

mariadbd --user=mysql --skip-networking &
pid="$!"

until mariadb-admin --user=root --password="${DB_ROOT_PASSWORD}" ping >/dev/null 2>&1; do
    sleep 1
done

mariadb -u root -p"${DB_ROOT_PASSWORD}" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown

wait "$pid"

exec "$@"
