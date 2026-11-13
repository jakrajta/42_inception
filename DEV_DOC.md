# Developer Documentation

## Prerequisites

The project requires:

* A Linux virtual machine
* Docker
* Docker Compose
* GNU Make
* Git

The project must be run inside the virtual machine required by the 42 Inception subject.

## Project Structure

The main configuration is located in:

```
srcs/docker-compose.yml
```

Each service has its own directory and Dockerfile:

```
srcs/requirements/
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

The `Makefile` is used to build, start and manage the infrastructure.

## Configuration

The Docker Compose configuration defines the services, networks, volumes, environment variables and Docker secrets.

The project domain is:

```
jakrajic.42.fr
```

Sensitive credentials are provided through Docker secrets.

Secrets must be created locally and must not be committed to Git.

## Setting Up the Environment

Clone the project and enter the project directory:

```
git clone <repository>
cd <repository name>
```

Create the environment file and the Docker secrets:

```bash
make setup
```

This copies `srcs/.env.example` to `srcs/.env` and asks for each password, which it saves to `secrets/*.txt` (existing files are kept). For manual setup and a description of every variable and secret, see the **Setup** section in `README.md`.

The secrets contain sensitive information such as database and service passwords. Both `srcs/.env` and `secrets/*.txt` are ignored by Git.

Make sure the required data directories can be created under:

```
/home/jakrajic/data/
```

## Building and Launching

Build the images and start the infrastructure:

```bash
make
```

The Makefile creates the required data directories, builds the Docker images and starts the containers.

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

To build the images without starting the containers:

```bash
make build
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml build
```

To start existing containers:

```bash
make start
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml start
```

Alternatively, start the infrastructure with Docker Compose through the Makefile:

```bash
make up
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

## Container Management

Check the running containers:

```bash
make status
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Stop containers:

```bash
make stop
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml stop
```

Stop and remove containers:

```bash
make down
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml down
```

Restart containers:

```bash
make restart
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml restart
```

View logs:

```bash
make logs
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

View only monitor logs:

```bash
make monitor
```

Equivalent Docker Compose command:

```bash
docker compose -f srcs/docker-compose.yml logs -f monitor
```

## Volumes and Persistent Data

The project uses Docker named volumes for persistent WordPress and MariaDB data.

The persistent data is stored under:

```
/home/jakrajic/data/wordpress
/home/jakrajic/data/mariadb
```

### WordPress

```
/home/jakrajic/data/wordpress
```

Contains the persistent WordPress website files.

### MariaDB

```
/home/jakrajic/data/mariadb
```

Contains the persistent MariaDB database files.

The data persists when containers are stopped or recreated.

To remove containers and volumes:

```
make down-volumes
```

## Complete Cleanup

To remove containers, images, volumes and persistent project data:

```
make fclean
```

This command also removes:

```
/home/jakrajic/data/wordpress
/home/jakrajic/data/mariadb
```

**Warning:** `make fclean` permanently removes the persistent project data.

The secrets in `secrets/*.txt` and `srcs/.env` are **not** removed by `make fclean`.

## Full Reset

To start completely from scratch, including credentials:

```
make reset
```

This runs `make fclean` and additionally deletes `secrets/*.txt` and `srcs/.env`. The next `make` (or `make setup`) recreates `srcs/.env` from `srcs/.env.example` and asks for new passwords.

**Warning:** any changes made to `srcs/.env` are lost.

## Accessing Containers

To open an interactive shell inside a running container:

```bash
docker exec -it <container_name> bash
```
For example:

```bash
docker exec -it inception-nginx-1 bash
```

The container name can be checked with:

```bash
docker ps
```

## Docker Compose

Docker Compose is used to define and manage the complete multi-container infrastructure.

The Compose file is:

```
srcs/docker-compose.yml
```

Each service runs in its own container and communicates with the other services through the dedicated Docker network.
