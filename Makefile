.DEFAULT_GOAL := help

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

DESKTOP_PATH ?= ~/Desktop/

help:           ## Show help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

############
## Docker ##
############

## up : Pull images + build and setup containers
up:
	@echo "Starting up containers..."
	docker compose pull
	docker compose up -d --wait --remove-orphans --build

## ps	:	List containers.
ps: 
	@echo "Listing containers..."
	docker compose ps

## logs	:	Logs containers.
logs: 
	@echo "Getting containers logs..."
	docker compose logs

## start : Start containers without updating.
start:
	@echo "Starting containers from where you left off..."
	@docker compose start

## stop	:	Stop containers.
stop:
	@echo "Stopping containers..."
	@docker compose stop

## prune : Remove containers and their volumes.
##		You can optionally pass an argument with the service name to prune single container
##		prune mariadb	: Prune `mariadb` container and remove its volumes.
prune:
	@echo "Removing containers..."
	@docker compose down -v $(filter-out $@,$(MAKECMDGOALS))

## shell : Connect to container.
shell:
	docker exec -it $(PROJECT_NAME) bash

#############
## PROCESS ##
#############

## copy-env-file : Copy .env file.
.PHONY: copy-env-file
copy-env-file:
	cp .env.dist .env

## create-setup : Setup local project from existing Git project.
##		For example: make create-setup "<project_name> <repo-git>"
.PHONY: create-setup
create-setup:
	mv ${DESKTOP_PATH}strapi-pro-docker ${DESKTOP_PATH}$(word 2, $(MAKECMDGOALS))-docker
	git clone $(word 3, $(MAKECMDGOALS)) ${DESKTOP_PATH}$(word 2, $(MAKECMDGOALS))-docker/backend
	$(MAKE) copy-env-file

## create-init : Setup local project.
##		For example: make create-init "<project_name>"
.PHONY: create-init
create-init:
	mv ${DESKTOP_PATH}strapi-pro-docker ${DESKTOP_PATH}$(word 2, $(MAKECMDGOALS))-docker
	mkdir ${DESKTOP_PATH}$(word 2, $(MAKECMDGOALS))-docker/backend
	$(MAKE) copy-env-file

## init : Create local project.
.PHONY: init
init:
	rm -rf ./backend
	yarn create strapi-app --no-run --ts --dbclient "${DATABASE_CLIENT}" --dbhost "${DATABASE_HOST}" --dbport "${DATABASE_PORT}" --dbname "${DATABASE_USERNAME}" --dbusername "${DATABASE_USERNAME}" --dbpassword "${DATABASE_PASSWORD}" --dbssl "${DATABASE_SSL}" backend
	$(MAKE) up
	$(MAKE) strapi-admin-init

############
## STRAPI ##
############

## strapi-config-dump : Dumps configurations to a file or stdout to help you migrate to production.
##		For example: make strapi-config-dump "dump.json"
strapi-config-dump:
	docker exec ${PROJECT_NAME} strapi configuration:dump -f $(filter-out $@,$(MAKECMDGOALS))

## strapi-config-restore : Restores a configuration dump into your application.
##		For example: make strapi-config-restore "dump.json"
strapi-config-restore:
	docker exec ${PROJECT_NAME} strapi configuration:restore -f $(filter-out $@,$(MAKECMDGOALS))

## strapi-admin-init : Creates the first administrator.
##		For example: make strapi-admin-init
strapi-admin-init:
	$(MAKE) strapi-admin-create OPTIONS="--firstname=${ADMIN_STRAPI_NAME} --email=${ADMIN_STRAPI_MAIL} --password=${ADMIN_STRAPI_PASSWORD}"

## strapi-admin-create : Creates an administrator.
##		For example: make strapi-admin-create OPTIONS="--firstname=Kai --lastname=Doe --email=chef@strapi.io --password=Gourmet1234"
strapi-admin-create:
	docker exec ${PROJECT_NAME} strapi admin:create-user $(OPTIONS)

## strapi-admin-reset-password : Reset an admin user's password.
##		For example: make strapi-admin-reset-password OPTIONS="--email=chef@strapi.io --password=Gourmet1234"
strapi-admin-reset-password:
	docker exec ${PROJECT_NAME} strapi admin:reset-user-password $(OPTIONS)

## strapi-install : Install packages from package.json & yarn.lock.
strapi-install:
	docker exec ${PROJECT_NAME} yarn install

## strapi-build : Build strapi app from packages.
strapi-build:
	docker exec ${PROJECT_NAME} yarn build

## strapi-dev : Dev mode.
strapi-dev:
	docker exec -d ${PROJECT_NAME} yarn develop

## strapi-add : Install a plugin in the project.
##		For example: make strapi-add "@_sh/strapi-plugin-ckeditor"
strapi-add:
	docker exec ${PROJECT_NAME} yarn add $(filter-out $@,$(MAKECMDGOALS))

## strapi-remove : Uninstall a plugin in the project.
##		For example: make strapi-remove "@_sh/strapi-plugin-ckeditor"
strapi-remove:
	docker exec ${PROJECT_NAME} yarn remove $(filter-out $@,$(MAKECMDGOALS))

# https://stackoverflow.com/a/6273809/1826109
%:
	@: