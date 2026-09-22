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

Create the required Docker secret files according to the configuration in `docker-compose.yml`.

The secrets contain sensitive information such as database and service passwords.

Make sure the required data directories can be created under:

```
/home/jakrajic/data/
```

## Building and Launching

Build the images and start the infrastructure:

```
make
```

The Makefile creates the required data directories, builds the Docker images and starts the containers.

To build the images without starting the containers:

```
make build
```

To start existing containers:

```
make start
```

Alternatively, start the infrastructure with Docker Compose through the Makefile:

```
make up
```

## Container Management

Check the running containers:

```
make status
```

Stop containers:

```
make stop
```

Stop and remove containers:

```
make down
```

Restart containers:

```
make restart
```

View logs:

```
make logs
```

View only monitor logs:

```
make monitor
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

## Docker Compose

Docker Compose is used to define and manage the complete multi-container infrastructure.

The Compose file is:

```
srcs/docker-compose.yml
```

Each service runs in its own container and communicates with the other services through the dedicated Docker network.
