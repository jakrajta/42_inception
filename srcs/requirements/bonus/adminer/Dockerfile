FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
	php-cli \
	#php je program (jako python), ktery umy programy .php spoustet. stejne jako 
	# python spusti programy .py .hp ma ruzne ruzne rozsireni a moduly(php8.2-cli ...)
	# php-cli naistaluje php do kontejneru. adminer je program.php
	# cli -commad line interface
	php-mysql \
	# umozni komunikaci s mariadb
	php-mbstring \
	# prace s textem i mimo anglictinu (multibyte string)
	php-xml \
	# nektere php potrebuji alplikace xml( xml slouzi k ulozeni a redavani dat)
	wget \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget -O index.php https://www.adminer.org/latest-mysql.php
# index.php je hlavni stranka webu

COPY tools/adminer_init.sh /usr/local/bin/adminer_init.sh

RUN chmod +x /usr/local/bin/adminer_init.sh

EXPOSE 8080
# na tomto portu bude adminer poslouchat

ENTRYPOINT ["/usr/local/bin/adminer_init.sh"]


# puvodne jsem u php8.2 veri a debian si stejne vybere 8.2

# do nginx.conf pridano location proxy

# adminer se pripojuje do databaze maiadb, ktera se jmenuje wordpress
# je jedna databaze, ale 2 volumes

# https://jakrajic.42.fr/adminer/
# System:   MySQL
# Server:   mariadb
# Username: wpuser
# Password: heslo z db_user_password.txt
# Database: wordpress

#                     INCEPTION
#                        │
#           ┌────────────┴────────────┐
#           │                         │
#        MariaDB                   WordPress
#           │                         │
#           ↓                         ↓
#    mariadb_data              wordpress_data
#           │                         │
#           ↓                         ↓
#    databáze wordpress        WordPress soubory
#           │                         │
#           ↓                         ↓
#    wp_users                  wp-admin/
#    wp_posts                  wp-content/
#    wp_options                wp-includes/
#    ...                       ...