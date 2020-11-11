PROJECT_NAME ?= todobackend
ORG_NAME ?= kubusb
REPO_NAME ?= todobackend

# Filenames
DEV_COMPOSE_FILE := docker/dev/docker-compose.yml
REL_COMPOSE_FILE := docker/release/docker-compose.yml

REL_PROJECT := $(PROJECT_NAME)$(BUILD_ID)
DEV_PROJECT := $(REL_PROJECT)_dev

.PHONY: test build release clean

test:
	$(INFO) "Running tests"
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up agent
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up test

build:
	$(INFO) "Building images"
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up builder
	$(INFO) "Build completed"

release:
	$(INFO) "Releaseing"
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) build
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up agent
	$(INFO) "Collecting static content"
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py collectstatic --noinput
	$(INFO) "Migrating data to the database"
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py migrate --noinput
	$(INFO) "Running tests"
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up test
	$(INFO) "Release completed" $(date)

clean:
	$(INFO) "Destroying development environment..."
	docker-compose -p $(REL_PROJECT) -f $(DEV_COMPOSE_FILE) kill
	docker-compose -p $(REL_PROJECT) -f $(DEV_COMPOSE_FILE) rm -f -v
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) kill
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) rm -f -v
	docker images -q -f dangling=true -f label=application=$(REPO_NAME) | xargs -I ARGS docker rmi -f ARGS
	$(INFO) "Clean complete"
# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"
BLUE := "\e[1;34m"

# Shell functions
INFO := @bash -c '\
	printf $(BLUE); \
	echo "----- $$1 -----"; \
	printf $(NC)' VALUE
