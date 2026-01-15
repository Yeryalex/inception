NAME = inception

# Use a variable for the command (easier to change if the machine is old)
COMPOSE = docker compose -f srcs/docker-compose.yml

all: build

build:
	@mkdir -p /home/yrodrigu/data/wordpress
	@mkdir -p /home/yrodrigu/data/mariadb
	@$(COMPOSE) up -d --build

stop:
	@$(COMPOSE) stop

start:
	@$(COMPOSE) start

down:
	@$(COMPOSE) down

# Added sudo to ensure the data folder is actually deleted
# Added volume prune to ensure no "ghost" volumes remain
clean:
	@$(COMPOSE) down -v
	@sudo rm -rf /home/yrodrigu/data
	@docker volume prune -f

fclean: clean
	@docker system prune -af

re: fclean all

.PHONY: all build stop start down clean fclean re
