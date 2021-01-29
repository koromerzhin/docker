.DEFAULT_GOAL := help


SUPPORTED_COMMANDS := contributors git docker linter logs
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMAND_ARGS):;@:)
endif
%:
	@:

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

package-lock.json: package.json
	@npm install

node_modules: package-lock.json
	@npm install

install: node_modules ## Installation application

contributors: ## Contributors
ifeq ($(COMMAND_ARGS),add)
	@npm run contributors add
else ifeq ($(COMMAND_ARGS),check)
	@npm run contributors check
else ifeq ($(COMMAND_ARGS),generate)
	@npm run contributors generate
else
	@npm run contributors
endif

git: ## Scripts GIT
ifeq ($(COMMAND_ARGS),commit)
	@npm run commit
else ifeq ($(COMMAND_ARGS),check)
	@make contributors check -i
	@make linter all -i
	@git status
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make git ARGUMENT"
	@echo "---"
	@echo "commit: Commit data"
	@echo "check: CHECK before"
endif

docker: ## Scripts docker
ifeq ($(COMMAND_ARGS),images)
	@docker images
else ifeq ($(COMMAND_ARGS),generate)
	@make docker generate-django -i
	@make docker generate-nodejs -i
	@make docker generate-phpfpm -i
else ifeq ($(COMMAND_ARGS),generate-django)
	@docker build -t koromerzhin/django:latest images/django
	@docker image tag koromerzhin/django:latest koromerzhin/django:3.9.0
else ifeq ($(COMMAND_ARGS),generate-nodejs)
	@echo "Generate Nodejs"
	@docker build -t koromerzhin/nodejs:latest images/nodejs
	@docker image tag koromerzhin/nodejs:latest koromerzhin/nodejs:15.1.0
	@echo "Generate angular"
	@docker build -t koromerzhin/nodejs:latest-angular images/nodejs/angular
	@docker image tag koromerzhin/nodejs:latest-angular koromerzhin/nodejs:10.2.0-angular
	@echo "Generate React"
	@docker build -t koromerzhin/nodejs:latest-react images/nodejs/react
	@docker image tag koromerzhin/nodejs:latest-react koromerzhin/nodejs:16.13.1-react
	@echo "Generate Sveltejs"
	@docker build -t koromerzhin/nodejs:latest-sveltejs images/nodejs/sveltejs
	@docker image tag koromerzhin/nodejs:latest-sveltejs koromerzhin/nodejs:3.29.4-sveltejs
	@echo "Generate Vuejs"
	@docker build -t koromerzhin/nodejs:latest-vuejs images/nodejs/vuejs
	@docker image tag koromerzhin/nodejs:latest-vuejs koromerzhin/nodejs:4.5.8-vuejs
	@echo "Generate Quarsar"
	@docker build -t koromerzhin/nodejs:latest-quasar images/nodejs/quasar
	@docker image tag koromerzhin/nodejs:latest-quasar koromerzhin/nodejs:1.1.3-quasar
else ifeq ($(COMMAND_ARGS),generate-phpfpm)
	@echo "Generate PHPFPM"
	@docker build -t koromerzhin/phpfpm:latest images/phpfpm
	@docker image tag koromerzhin/phpfpm:latest koromerzhin/phpfpm:7.4.12
	@echo "Generate XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-xdebug images/phpfpm/xdebug
	@docker image tag koromerzhin/phpfpm:latest-xdebug koromerzhin/phpfpm:7.4.12-xdebug
	@echo "Generate Symfony"
	@docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm/symfony
	@docker image tag koromerzhin/phpfpm:latest-symfony koromerzhin/phpfpm:7.4.12-symfony
	@echo "Generate Symfony XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-symfony-xdebug images/phpfpm/symfony-xdebug
	@docker image tag koromerzhin/phpfpm:latest-symfony-xdebug koromerzhin/phpfpm:7.4.12-symfony-xdebug
else ifeq ($(COMMAND_ARGS),login)
	@docker login
else ifeq ($(COMMAND_ARGS),push)
	@make docker push-django
	@make docker push-nodejs
	@make docker push-phpfpm
else ifeq ($(COMMAND_ARGS),push-django)
	@docker push koromerzhin/django -a
else ifeq ($(COMMAND_ARGS),push-nodejs)
	@docker push koromerzhin/nodejs -a
else ifeq ($(COMMAND_ARGS),push-phpfpm)
	@docker push koromerzhin/phpfpm -a
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make docker ARGUMENT"
	@echo "---"
	@echo "images: images"
	@echo "check: CHECK before"
	@echo "generate: generate all images"
	@echo "generate-django: generate all django images"
	@echo "generate-nodejs: generate all nodejs images"
	@echo "generate-phpfpm: generate all nodejs images"
	@echo "login: login"
	@echo "push: push all images"
	@echo "push-django: push all django images"
	@echo "push-nodejs: push all nodejs images"
	@echo "push-phpfpm: push all phpfpm images"
endif

linter: ## Scripts Linter
ifeq ($(COMMAND_ARGS),all)
	@make linter readme -i
	@make linter docker-nodejs -i
	@make linter docker-django -i
	@make linter docker-phpfpm -i
else ifeq ($(COMMAND_ARGS),readme)
	@npm run linter-markdown README.md
else ifeq ($(COMMAND_ARGS),docker-nodejs)
	@npm run linter-docker images/nodejs/Dockerfile
	@npm run linter-docker images/nodejs/*/Dockerfile
else ifeq ($(COMMAND_ARGS),docker-django)
	@npm run linter-docker images/django/Dockerfile
else ifeq ($(COMMAND_ARGS),docker-phpfpm)
	@npm run linter-docker images/phpfpm/Dockerfile
	@npm run linter-docker images/phpfpm/*/Dockerfile
else ifeq ($(COMMAND_ARGS),docker)
	@make linter docker-nodejs -i
	@make linter docker-django -i
	@make linter docker-phpfpm -i
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make linter ARGUMENT"
	@echo "---"
	@echo "all: all"
	@echo "readme: linter README.md"
	@echo "docker: linter docker"
	@echo "docker-nodejs: linter docker nodejs"
	@echo "docker-django: linter docker django"
	@echo "docker-phpfpm: linter docker phpfpm"
endif