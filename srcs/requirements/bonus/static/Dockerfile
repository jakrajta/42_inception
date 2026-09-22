FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
	python3 \
	&& rm -rf /var/lib/apt/lists/*

COPY html/ /var/www/html/

EXPOSE 8080

CMD ["python3", "-m", "http.server", "8080", "--directory", "/var/www/html"]
