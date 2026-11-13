*This project has been created as part of the 42 curriculum by jakrajic.*

# Inception

## Description

Inception is a 42 system administration project focused on building a small infrastructure using Docker Compose.

Each service runs in its own container and is built from a custom Dockerfile based on Debian:bookworm. The infrastructure runs inside a virtual machine.

### Services

**Mandatory:**

* **NGINX** – HTTPS entry point using TLS 1.2/1.3.
* **WordPress + PHP-FPM** – web application.
* **MariaDB** – WordPress database.

**Bonus:**

* **Redis** – WordPress object cache.
* **FTP / vsftpd** – access to WordPress files.
* **Adminer** – database management interface.
* **Static website** – simple HTML website.
* **Monitor** – checks WordPress availability through NGINX.

The services communicate through a dedicated Docker network.

Persistent data is stored in Docker named volumes:

```text
/home/jakrajic/data/wordpress
/home/jakrajic/data/mariadb
```

---

## Architecture

```text
                  HTTPS :443
                      |
                    NGINX
                      |
                      v
              WordPress + PHP-FPM
                      |
                      v
                   MariaDB

              + Redis
              + FTP
              + Adminer
              + Static website
              + Monitor
```

NGINX is the only public entry point for the mandatory infrastructure.

---

## Project Structure

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/                 # *.txt password files (not in Git)
└── srcs/
    ├── .env.example         # template for srcs/.env (not in Git)
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        ├── wordpress/
        └── bonus/
            ├── adminer/
            ├── ftp/
            ├── monitor/
            ├── redis/
            └── static/
```

Each service has its own Dockerfile and configuration/scripts.

---

## Technical Choices

### Docker vs Virtual Machine

A virtual machine runs a complete guest operating system. Docker containers share the host kernel and isolate individual services.

This project uses both: the infrastructure runs inside a VM and Docker isolates the services.

### Secrets vs Environment Variables

Environment variables are used for configuration such as the domain name.

Sensitive credentials are stored using Docker secrets and are not hard-coded in Dockerfiles or committed to Git.

### Docker Network vs Host Network

A Docker network provides isolated communication between containers using service names.

Host networking would expose containers directly to the host network. A dedicated Docker network is therefore used for the infrastructure.

### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and provide persistent storage.

The project uses named volumes for WordPress and MariaDB, with their data stored under:

```text
/home/jakrajic/data/
```

---

## Setup

The repository does **not** contain any credentials. Before the first run you need:

1. `srcs/.env` – non-sensitive configuration (domain, database name, usernames)
2. `secrets/*.txt` – one password per file, mounted into containers as Docker secrets

### Quick setup

```bash
make setup
```

This creates `srcs/.env` from `srcs/.env.example` and asks you to type a password for every missing secret file (input is hidden). Existing files are never overwritten. `make` runs this step automatically.

To look up a password later (e.g. for the WordPress admin login):

```bash
cat secrets/wp_admin_password.txt
```

### Manual setup

**1. Environment file**

```bash
cp srcs/.env.example srcs/.env
```

| Variable         | Description                                      | Example               |
|------------------|--------------------------------------------------|-----------------------|
| `DB_NAME`        | WordPress database name                          | `wordpress`           |
| `DB_USER`        | MariaDB user for WordPress                       | `wpuser`              |
| `DB_HOST`        | MariaDB host (Compose service name)              | `mariadb`             |
| `DOMAIN_NAME`    | Domain served by NGINX                           | `jakrajic.42.fr`      |
| `WP_ADMIN_USER`  | WordPress administrator (must not contain *admin*) | `wpowner`           |
| `WP_ADMIN_EMAIL` | Administrator e-mail                             | `wpowner@example.com` |
| `WP_USER`        | Regular WordPress user (author)                  | `student`             |
| `WP_USER_EMAIL`  | Regular user e-mail                              | `student@example.com` |

**2. Secrets**

```bash
mkdir -p secrets
printf '%s' 'your-db-root-password'  > secrets/db_root_password.txt
printf '%s' 'your-db-user-password'  > secrets/db_user_password.txt
printf '%s' 'your-wp-admin-password' > secrets/wp_admin_password.txt
printf '%s' 'your-wp-user-password'  > secrets/wp_user_password.txt
printf '%s' 'your-ftp-password'      > secrets/ftp_user_password.txt
```

| File                    | Used by             | Purpose                         |
|-------------------------|---------------------|---------------------------------|
| `db_root_password.txt`  | MariaDB             | MariaDB `root` password         |
| `db_user_password.txt`  | MariaDB, WordPress  | Password of `DB_USER`           |
| `wp_admin_password.txt` | WordPress           | Password of `WP_ADMIN_USER`     |
| `wp_user_password.txt`  | WordPress           | Password of `WP_USER`           |
| `ftp_user_password.txt` | FTP                 | Password of the `ftpuser` account |

Both `srcs/.env` and `secrets/*.txt` are listed in `.gitignore`.

> Passwords are applied only when the database and WordPress are initialised for the first time. After changing them, run `make fclean` and `make` again.

### Domain

Point the domain to your machine, for example:

```bash
echo "127.0.0.1 jakrajic.42.fr static.jakrajic.42.fr" | sudo tee -a /etc/hosts
```

---

## Instructions

### Start the project

```bash
make
```

### Build images

```bash
make build
```

### Start / stop

```bash
make start
make stop
```

### Start with Docker Compose

```bash
make up
```

### Stop and remove containers

```bash
make down
```

### Remove containers and volumes

```bash
make down-volumes
```

### Complete cleanup

```bash
make fclean
```

This also removes the persistent WordPress and MariaDB data.

### Check status

```bash
make status
```

### View logs

```bash
make logs
```

### View monitor

```bash
make monitor
```

---

## Domain

The WordPress website is available through:

```text
https://jakrajic.42.fr
```

The domain points to the local IP address of the virtual machine.

---

## Persistent Data

WordPress files:

```text
/home/jakrajic/data/wordpress
```

MariaDB data:

```text
/home/jakrajic/data/mariadb
```

The data persists when containers are recreated.

---

## Bonus

### Redis

Redis stores frequently accessed WordPress objects in memory to reduce repeated database queries.

WordPress communicates with Redis through the `object-cache.php` drop-in.

### FTP

The FTP service uses vsftpd and provides access to the WordPress volume.

### Adminer

Adminer provides a web interface for managing the MariaDB database.

### Static Website

A simple static HTML website is provided without PHP.

### Monitor

The monitor checks the WordPress website every 30 seconds through NGINX and reports whether it is reachable.

---

## Security

* TLS 1.2/1.3 is used for HTTPS.
* Credentials are stored using Docker secrets.
* Passwords are not hard-coded in Dockerfiles.
* The `latest` tag is not used.
* Services communicate through a dedicated Docker network.
* Persistent data is stored in Docker named volumes.

---

## Resources

* Docker OS version: https://www.debian.org/releases/index.en.html
* Docker documentation: https://docs.docker.com/
* Docker Compose documentation: https://docs.docker.com/compose/
* NGINX documentation: https://nginx.org/en/docs/
* WordPress Developer Documentation: https://developer.wordpress.org/
* MariaDB documentation: https://mariadb.com/docs/
* Redis documentation: https://redis.io/docs/
* Adminer: https://www.adminer.org/

### AI Usage

AI was used as a learning and development aid for:

* understanding Docker and Docker Compose;
* understanding NGINX, WordPress, PHP-FPM and MariaDB;
* understanding Redis, FTP and Adminer;
* troubleshooting configuration and scripts;
* preparing project documentation and evaluation explanations.
