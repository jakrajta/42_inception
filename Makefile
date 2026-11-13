COMPOSE = docker compose -f srcs/docker-compose.yml
SECRETS = db_root_password db_user_password wp_admin_password wp_user_password ftp_user_password

all: setup create-data
	$(COMPOSE) up -d --build


setup:
	@if [ ! -f srcs/.env ]; then \
		cp srcs/.env.example srcs/.env; \
		echo "Created srcs/.env from srcs/.env.example"; \
	fi
	@mkdir -p secrets
	@for s in $(SECRETS); do \
		if [ ! -f secrets/$$s.txt ]; then \
			while true; do \
				printf "Enter $$s: "; stty -echo; read -r pw; stty echo; echo; \
				[ -n "$$pw" ] && break; \
				echo "Password must not be empty."; \
			done; \
			printf '%s' "$$pw" > secrets/$$s.txt; \
			echo "Saved secrets/$$s.txt"; \
		fi; \
	done

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

reset: fclean
	rm -f secrets/*.txt srcs/.env
	rm -rf secrets

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

.PHONY: all setup create-data build up down down-volumes fclean reset start stop restart status logs monitor
