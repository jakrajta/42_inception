FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
	vsftpd \
	&& rm -rf /var/lib/local/lists/*

RUN mkdir -p /var/run/vsftpd/empty

RUN useradd -m -d /var/www/html ftpuser     

COPY config/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/ftp_init.sh /usr/local/bin/ftp_init.sh

RUN chmod +x /usr/local/bin/ftp_init.sh

CMD ["/usr/local/bin/ftp_init.sh"]
