# User Documentation

## Overview

This document explains how to start, stop and use the Inception infrastructure.

The project provides a WordPress website with MariaDB and several bonus services.

## Services

### WordPress

The main website is available at:

`https://jakrajic.42.fr`

WordPress is served through NGINX using HTTPS.

### Adminer

Adminer provides a web interface for managing the MariaDB database.

It can be used to view and manage databases, tables and data.

Available at:

`https://jakrajic.42.fr/adminer`

To log in, the following database credentials are required:

System: MySQL
Server: mariadb
Username: the configured MariaDB user
Password: the configured MariaDB password
Database: the WordPress database

The database credentials are stored securely using Docker secrets and are not included in this documentation.

### FTP

The FTP service provides access to the WordPress files.

To connect locally:

```bash
ftp localhost
```
Login credentials:

Username: ftpuser
Password: the configured FTP password stored in Docker secrets

The FTP user has access to the WordPress files.

The FTP password is not included in this documentation or stored in the Git repository.

A FTP client such as FileZilla can be used to connect to the FTP server.

### Redis

Redis is used as a cache for WordPress.

It stores frequently used WordPress objects in memory to reduce repeated database queries.

### Static Website

The project also contains a simple static HTML website.

The website is available at:

`https://static.jakrajic.42.fr`

### Monitor

The monitor checks whether the WordPress website is reachable through NGINX.

It performs a check every 30 seconds.

Available at:

```bash
make monitor
```

## Starting the Project

From the project root:

```bash
make
```

This creates the required data directories, builds the Docker images and starts all containers.

## Stopping the Project

To stop the containers:

```bash
make stop
```

To stop and remove the containers:

```bash
make down
```

## Starting Again

If the containers already exist:

```bash
make start
```

To rebuild the images:

```bash
make build
```

## Checking That Services Are Running Correctly

Check the status of all containers:

```bash
make status
```

To inspect service logs:

```bash
make logs
```

The project also uses health checks for important services to verify that they are running correctly.


## Data Persistence

The WordPress files and MariaDB database are stored persistently.

* WordPress data: `/home/jakrajic/data/wordpress`
* MariaDB data: `/home/jakrajic/data/mariadb`

The data remains available when containers are stopped or recreated.

## Credentials

Database and service credentials are stored using Docker secrets.

They are not stored directly in Dockerfiles or committed to the Git repository.

## Health Checks

The project uses health checks to verify the availability of important services.

The monitor additionally checks the WordPress website through NGINX every 30 seconds.

## Complete Cleanup

To remove containers, images, volumes and persistent project data:

```bash
make fclean
```

**Warning:** this command deletes the persistent WordPress and MariaDB data.
