<?php

define( 'DB_NAME', '${DB_NAME}' );
define( 'DB_USER', '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_USER_PASSWORD}' );
define( 'DB_HOST', '${DB_HOST}' );


define( 'DB_CHARSET', 'utf8mb4' );

define( 'DB_COLLATE', '' );

define( 'AUTH_KEY', '${AUTH_KEY}' );
t
define( 'SECURE_AUTH_KEY', '${SECURE_AUTH_KEY}' );

define( 'LOGGED_IN_KEY', '${LOGGED_IN_KEY}' );

define( 'NONCE_KEY', '${NONCE_KEY}' );
define( 'AUTH_SALT', '${AUTH_SALT}' );
define( 'SECURE_AUTH_SALT', '${SECURE_AUTH_SALT}' );
define( 'LOGGED_IN_SALT', '${LOGGED_IN_SALT}' );
define('NONCE_SALT', '${NONCE_SALT}' );

define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );


$table_prefix = 'wp_';

define( 'WP_DEBUG', false );


if ( !defined( 'ABSPATH') ) 
{
	define( 'ABSPATH', __DIR__ . '/' );
}
if (isset($_SERVER['HTTP_HOST'])) 
{
	define('WP_HOME', 'https://' . $_SERVER['HTTP_HOST']);
	define('WP_SITEURL', 'https://' . $_SERVER['HTTP_HOST']);
}

require_once ABSPATH . 'wp-settings.php';

