NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all: build

build:
	@sudo mkdir -p /home/yrodrigu/data/wordpress
	@sudo mkdir -p /home/yrodrigu/data/mariadb
	@$(COMPOSE) up -d --build

stop:
	@$(COMPOSE) stop

start:
	@$(COMPOSE) start

down:
	@$(COMPOSE) down

clean:
	@$(COMPOSE) down -v
	@sudo rm -rf /home/yrodrigu/data
	@docker volume prune -f

fclean: clean
	@docker system prune -af

re: fclean all

.PHONY: all build stop start down clean fclean re
