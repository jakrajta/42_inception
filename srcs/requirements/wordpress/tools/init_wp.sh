#!/bin/sh

set -eu

WP_DIR="/var/www/html"

if echo "$DB_HOST" | grep -q ':'; then
	DB_PORT="${DB_HOST##*:}"
else
	DB_PORT="3306"
fi

until nc -z -w 2 mariadb "$DB_PORT" > /dev/null 2>&1; do
	sleep 2
done

if [ ! -f "$WP_DIR/wp-load.php" ]; then
	cp -a /usr/local/share/wordpress/. "$WP_DIR/"
fi

if [ ! -d "$WP_DIR/wp-content/plugins/redis-cache" ]; then
	cp -a /usr/local/share/wordpress/wp-content/plugins/redis-cache \
		"$WP_DIR/wp-content/plugins/"
fi

if [ ! -f "$WP_DIR/wp-config.php" ]; then

	DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
	AUTH_KEY=$(openssl rand -hex 32)
	SECURE_AUTH_KEY=$(openssl rand -hex 32)
	LOGGED_IN_KEY=$(openssl rand -hex 32)
	NONCE_KEY=$(openssl rand -hex 32)

	AUTH_SALT=$(openssl rand -hex 32)
	SECURE_AUTH_SALT=$(openssl rand -hex 32)
	LOGGED_IN_SALT=$(openssl rand -hex 32)
	NONCE_SALT=$(openssl rand -hex 32)

	export DB_USER_PASSWORD
	
	export AUTH_KEY
	export SECURE_AUTH_KEY
	export LOGGED_IN_KEY
	export NONCE_KEY
	export AUTH_SALT
	export SECURE_AUTH_SALT
	export LOGGED_IN_SALT
	export NONCE_SALT

	envsubst '${DB_NAME} ${DB_USER} ${DB_USER_PASSWORD} ${DB_HOST} \
		${AUTH_KEY} ${SECURE_AUTH_KEY} ${LOGGED_IN_KEY} ${NONCE_KEY} \
		${AUTH_SALT} ${SECURE_AUTH_SALT} ${LOGGED_IN_SALT} ${NONCE_SALT}' \
		< /usr/local/share/wordpress/wp-config.php.template \
		 > "$WP_DIR/wp-config.php"
fi

if [ -f "$WP_DIR/wp-config.php" ]; then
	sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', '${DB_HOST}' );/" \
		"$WP_DIR/wp-config.php"
fi

chown -R www-data:www-data "$WP_DIR"

if ! wp core is-installed --path="$WP_DIR"  --allow-root; then
	wp core install \
		--path="$WP_DIR" \
		--allow-root \
		--url="https://${DOMAIN_NAME}" \
		--title="Inception" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$(cat /run/secrets/wp_admin_password)" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email

	wp user create \
		"$WP_USER" \
		"$WP_USER_EMAIL" \
		--path="$WP_DIR" \
		--allow-root \
		--role=subscriber \
		--user_pass="$(cat /run/secrets/wp_user_password)"

fi
wp plugin activate redis-cache \
	--path="$WP_DIR" \
	--allow-root

wp redis enable \
    --path="$WP_DIR" \
    --allow-root

exec "$@"

