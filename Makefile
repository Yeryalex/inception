COMPOSE_FILE := srcs/docker-compose.yml

PROJECT_DIR  := srcs

all: up

up:
	docker compose -f $(COMPOSE_FILE) --project-directory $(PROJECT_DIR) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) --project-directory $(PROJECT_DIR) down

re: down up

clean:
	docker compose -f $(COMPOSE_FILE) --project-directory $(PROJECT_DIR) down --rmi all --volumes

.PHONY: all up down re clean
