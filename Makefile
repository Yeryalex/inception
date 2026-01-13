NAME = inception

# Define the command to run docker-compose with the correct file path
COMPOSE = docker compose -f srcs/docker-compose.yml

all: build

# 1. Prepare directories and start the containers
build:
	@mkdir -p /home/yrodrigu/data/wordpress
	@mkdir -p /home/yrodrigu/data/mariadb
	@$(COMPOSE) up -d --build

# 2. Stop the containers without deleting them
stop:
	@$(COMPOSE) stop

# 3. Start the containers again
start:
	@$(COMPOSE) start

# 4. Shut down and remove containers + networks
down:
	@$(COMPOSE) down

# 5. Full clean: Remove containers, networks, and VOLUMES
# Use this if you want to reset your WordPress installation
clean:
	@$(COMPOSE) down -v
	@rm -rf /home/yrodrigu/data

# 6. Deep clean: Everything including images
fclean: clean
	@docker system prune -af

re: fclean all

.PHONY: all build stop start down clean fclean re
