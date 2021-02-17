isDocker := $(shell docker info > /dev/null 2>&1 && echo 1)

.DEFAULT_GOAL := help

SUPPORTED_COMMANDS := contributors git docker linter logs push docker-generate
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMAND_ARGS):;@:)
endif

.PHONY: help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

package-lock.json: package.json
	@npm install

node_modules: package-lock.json
	@npm install

.PHONY: isdocker
isdocker: ## Docker is launch
ifeq ($(isDocker), 0)
	@echo "Docker is not launch"
	exit 1
endif

install: node_modules ## Installation application

.PHONY: contributors
contributors: node_modules ## Contributors
ifeq ($(COMMAND_ARGS),add)
	@npm run contributors add
else ifeq ($(COMMAND_ARGS),check)
	@npm run contributors check
else ifeq ($(COMMAND_ARGS),generate)
	@npm run contributors generate
else
	@npm run contributors
endif

.PHONY: git
git: node_modules ## Scripts GIT
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

.PHONY: docker
docker: isdocker ## Scripts docker
ifeq ($(COMMAND_ARGS),images)
	@docker images
else ifeq ($(COMMAND_ARGS),login)
	@docker login
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make docker ARGUMENT"
	@echo "---"
	@echo "images: images"
	@echo "check: CHECK before"
	@echo "login: login"
endif

.PHONY: docker-generate
docker-generate: isdocker ## Generate image
ifeq ($(COMMAND_ARGS),all)
	@make docker-generate django -i
	@make docker-generate nodejs -i
	@make docker-generate phpfpm -i
else ifeq ($(COMMAND_ARGS),django)
	@docker build -t koromerzhin/django:latest images/django
	@docker image tag koromerzhin/django:latest koromerzhin/django:3.9.0
else ifeq ($(COMMAND_ARGS),nodejs)
	@make docker-generate nodejs-nodejs -i
	@make docker-generate nodejs-angular -i
	@make docker-generate nodejs-remotion -i
	@make docker-generate nodejs-react -i
	@make docker-generate nodejs-sveltejs -i
	@make docker-generate nodejs-vuejs -i
	@make docker-generate nodejs-quasar -i
else ifeq ($(COMMAND_ARGS),nodejs-nodejs)
	@echo "Generate Nodejs"
	@docker build -t koromerzhin/nodejs:latest images/nodejs
	@docker image tag koromerzhin/nodejs:latest koromerzhin/nodejs:15.1.0
else ifeq ($(COMMAND_ARGS),nodejs-angular)
	@echo "Generate angular"
	@docker build -t koromerzhin/nodejs:latest-angular images/nodejs/angular
	@docker image tag koromerzhin/nodejs:latest-angular koromerzhin/nodejs:10.2.0-angular
else ifeq ($(COMMAND_ARGS),nodejs-remotion)
	@echo "Generate Remotion"
	@docker build -t koromerzhin/nodejs:latest-remotion images/nodejs/remotion
	@docker image tag koromerzhin/nodejs:latest-remotion koromerzhin/nodejs:1.3.0-remotion
else ifeq ($(COMMAND_ARGS),nodejs-react)
	@echo "Generate React"
	@docker build -t koromerzhin/nodejs:latest-react images/nodejs/react
	@docker image tag koromerzhin/nodejs:latest-react koromerzhin/nodejs:16.13.1-react
else ifeq ($(COMMAND_ARGS),nodejs-sveltejs)
	@echo "Generate Sveltejs"
	@docker build -t koromerzhin/nodejs:latest-sveltejs images/nodejs/sveltejs
	@docker image tag koromerzhin/nodejs:latest-sveltejs koromerzhin/nodejs:3.29.4-sveltejs
else ifeq ($(COMMAND_ARGS),nodejs-vuejs)
	@echo "Generate Vuejs"
	@docker build -t koromerzhin/nodejs:latest-vuejs images/nodejs/vuejs
	@docker image tag koromerzhin/nodejs:latest-vuejs koromerzhin/nodejs:4.5.8-vuejs
else ifeq ($(COMMAND_ARGS),nodejs-quasar)
	@echo "Generate Quarsar"
	@docker build -t koromerzhin/nodejs:latest-quasar images/nodejs/quasar
	@docker image tag koromerzhin/nodejs:latest-quasar koromerzhin/nodejs:1.1.3-quasar
else ifeq ($(COMMAND_ARGS),phpfpm)
	@make docker-generate phpfpm-phpfpm -i
	@make docker-generate phpfpm-xdebug -i
	@make docker-generate phpfpm-symfony -i
	@make docker-generate phpfpm-symfony-xdebug -i
else ifeq ($(COMMAND_ARGS),phpfpm-phpfpm)
	@echo "Generate PHPFPM"
	@docker build -t koromerzhin/phpfpm:latest images/phpfpm
	@docker image tag koromerzhin/phpfpm:latest koromerzhin/phpfpm:7.4.12
else ifeq ($(COMMAND_ARGS),phpfpm-xdebug)
	@echo "Generate XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-xdebug images/phpfpm/xdebug
	@docker image tag koromerzhin/phpfpm:latest-xdebug koromerzhin/phpfpm:7.4.12-xdebug
else ifeq ($(COMMAND_ARGS),phpfpm-symfony)
	@echo "Generate Symfony"
	@docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm/symfony
	@docker image tag koromerzhin/phpfpm:latest-symfony koromerzhin/phpfpm:7.4.12-symfony
else ifeq ($(COMMAND_ARGS),phpfpm-symfony-xdebug)
	@echo "Generate Symfony XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-symfony-xdebug images/phpfpm/symfony-xdebug
	@docker image tag koromerzhin/phpfpm:latest-symfony-xdebug koromerzhin/phpfpm:7.4.12-symfony-xdebug
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make docker-generate ARGUMENT"
	@echo "---"
	@echo "images: images"
	@echo "check: CHECK before"
	@echo "all: generate all images"
	@echo "django: generate all django images"
	@echo "nodejs: generate all nodejs images"
	@echo "nodejs-nodejs: generate nodejs"
	@echo "nodejs-angular: generate angular"
	@echo "nodejs-remotion: generate remotion"
	@echo "nodejs-react: generate react"
	@echo "nodejs-sveltejs: generate sveltejs"
	@echo "nodejs-vuejs: generate vuejs"
	@echo "nodejs-quasar: generate quasar"
	@echo "phpfpm: generate all phpfpm images"
	@echo "phpfpm-phpfpm: generate phpfpm"
	@echo "phpfpm-xdebug: generate xdebug"
	@echo "phpfpm-symfony: generate symfony"
	@echo "phpfpm-symfony-xdebug: generate symfony-xdebug"
endif

.PHONY: linter
linter: node_modules ## Scripts Linter
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

.PHONY: push
push: isdocker ## push image
ifeq ($(COMMAND_ARGS),all)
	@make push django
	@make push nodejs
	@make push phpfpm
else ifeq ($(COMMAND_ARGS),django)
	@docker push koromerzhin/django
else ifeq ($(COMMAND_ARGS),nodejs)
	@docker push koromerzhin/nodejs
else ifeq ($(COMMAND_ARGS),phpfpm)
	@docker push koromerzhin/phpfpm
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make push ARGUMENT"
	@echo "---"
	@echo "all: push all images"
	@echo "django: push all django images"
	@echo "nodejs: push all nodejs images"
	@echo "phpfpm: push all phpfpm images"
endif