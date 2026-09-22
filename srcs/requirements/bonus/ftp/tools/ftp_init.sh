#!/bin/sh

set -eu

FTP_PASSWORD="$(cat /run/secrets/ftp_user_password)"

echo "ftpuser:$FTP_PASSWORD" | chpasswd

usermod -aG www-data ftpuser

chmod -R g+rwX /var/www/html/wp-content/plugins
chmod -R g+rwX /var/www/html/wp-content/themes
chmod -R g+rwX /var/www/html/wp-content/uploads

exec vsftpd /etc/vsftpd/vsftpd.conf
