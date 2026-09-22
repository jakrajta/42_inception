COMPOSE = docker compose -f srcs/docker-compose.yml

all: create-data
	$(COMPOSE) up -d --build


create-data:
	mkdir -p /home/jana/data/wordpress
	mkdir -p /home/jana/data/mariadb

build: create-data
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down: 
	$(COMPOSE) down

down-volumes:
	$(COMPOSE) down -v

fclean:
	$(COMPOSE) down -v --rmi all --remove-orphans
	docker system prune -af --volumes
	rm -rf /home/jana/data/wordpress
	rm -rf /home/jana/data/mariadb

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart:
	$(COMPOSE) restart

status:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

monitor:
	$(COMPOSE) logs -f monitor