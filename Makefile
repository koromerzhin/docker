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

node_modules:
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
ifeq ($(COMMAND_ARGS),check)
	@make contributors check -i
	@make linter all -i
	@git status
else
	@echo "ARGUMENT missing"
	@echo "---"
	@echo "make git ARGUMENT"
	@echo "---"
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
else ifeq ($(COMMAND_ARGS),nodejs-quasar)
	@echo "Generate Quarsar"
	@docker build -t koromerzhin/nodejs:latest-quasar images/nodejs/quasar
	@docker image tag koromerzhin/nodejs:latest-quasar koromerzhin/nodejs:1.1.3-quasar
else ifeq ($(COMMAND_ARGS),phpfpm)
	@make docker-generate phpfpm-phpfpm -i
	@make docker-generate phpfpm-xdebug -i
	@make docker-generate phpfpm-symfony -i
	@make docker-generate phpfpm-symfony-xdebug -i
	@make docker-generate phpfpm-all -i
	@make docker-generate phpfpm-all-xdebug -i
	@make docker-generate phpfpm-drupal -i
	@make docker-generate phpfpm-drupal-xdebug -i
	@make docker-generate phpfpm-wordpress -i
	@make docker-generate phpfpm-wordpress-xdebug -i
else ifeq ($(COMMAND_ARGS),phpfpm-phpfpm)
	@echo "Generate PHPFPM"
	@docker build -t koromerzhin/phpfpm:latest images/phpfpm
	@docker image tag koromerzhin/phpfpm:latest koromerzhin/phpfpm:8.0.9
else ifeq ($(COMMAND_ARGS),phpfpm-xdebug)
	@echo "Generate XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-xdebug images/phpfpm/xdebug
	@docker image tag koromerzhin/phpfpm:latest-xdebug koromerzhin/phpfpm:8.0.9-xdebug
else ifeq ($(COMMAND_ARGS),phpfpm-symfony)
	@echo "Generate Symfony"
	@docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm/symfony
	@docker image tag koromerzhin/phpfpm:latest-symfony koromerzhin/phpfpm:8.0.9-symfony
else ifeq ($(COMMAND_ARGS),phpfpm-symfony-xdebug)
	@echo "Generate Symfony XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-symfony-xdebug images/phpfpm/symfony/xdebug
	@docker image tag koromerzhin/phpfpm:latest-symfony-xdebug koromerzhin/phpfpm:8.0.9-symfony-xdebug
else ifeq ($(COMMAND_ARGS),phpfpm-all)
	@echo "Generate all"
	@docker build -t koromerzhin/phpfpm:latest-all images/phpfpm/all
	@docker image tag koromerzhin/phpfpm:latest-all koromerzhin/phpfpm:8.0.9-all
else ifeq ($(COMMAND_ARGS),phpfpm-all-xdebug)
	@echo "Generate all XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-all-xdebug images/phpfpm/all/xdebug
	@docker image tag koromerzhin/phpfpm:latest-all-xdebug koromerzhin/phpfpm:8.0.9-all-xdebug
else ifeq ($(COMMAND_ARGS),phpfpm-drupal)
	@echo "Generate drupal"
	@docker build -t koromerzhin/phpfpm:latest-drupal images/phpfpm/drupal
	@docker image tag koromerzhin/phpfpm:latest-drupal koromerzhin/phpfpm:8.0.9-drupal
else ifeq ($(COMMAND_ARGS),phpfpm-drupal-xdebug)
	@echo "Generate drupal XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-drupal-xdebug images/phpfpm/drupal/xdebug
	@docker image tag koromerzhin/phpfpm:latest-drupal-xdebug koromerzhin/phpfpm:8.0.9-drupal-xdebug
else ifeq ($(COMMAND_ARGS),phpfpm-wordpress)
	@echo "Generate wordpress"
	@docker build -t koromerzhin/phpfpm:latest-wordpress images/phpfpm/wordpress
	@docker image tag koromerzhin/phpfpm:latest-wordpress koromerzhin/phpfpm:8.0.9-wordpress
else ifeq ($(COMMAND_ARGS),phpfpm-wordpress-xdebug)
	@echo "Generate wordpress XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-wordpress-xdebug images/phpfpm/wordpress/xdebug
	@docker image tag koromerzhin/phpfpm:latest-wordpress-xdebug koromerzhin/phpfpm:8.0.9-wordpress-xdebug
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
	@echo "nodejs-express: generate express"
	@echo "nodejs-socketio: generate socketio"
	@echo "nodejs-angular: generate angular"
	@echo "nodejs-remotion: generate remotion"
	@echo "nodejs-react: generate react"
	@echo "nodejs-sveltejs: generate sveltejs"
	@echo "nodejs-vuejs: generate vuejs"
	@echo "nodejs-quasar: generate quasar"
	@echo "phpfpm: generate all phpfpm images"
	@echo "phpfpm-all: generate phpfpm with symfony drupal"
	@echo "phpfpm-all-xdebug: generate phpfpm with symfony drupal xdebug"
	@echo "phpfpm-phpfpm: generate phpfpm"
	@echo "phpfpm-xdebug: generate xdebug"
	@echo "phpfpm-symfony: generate symfony"
	@echo "phpfpm-symfony-xdebug: generate symfony-xdebug"
	@echo "phpfpm-drupal: generate drupal"
	@echo "phpfpm-drupal-xdebug: generate drupal-xdebug"
	@echo "phpfpm-wordpress: generate wordpress"
	@echo "phpfpm-wordpress-xdebug: generate wordpress-xdebug"
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
	@npm run linter-docker $$(find images/nodejs -name "Dockerfile")
else ifeq ($(COMMAND_ARGS),docker-django)
	@npm run linter-docker $$(find images/django -name "Dockerfile")
else ifeq ($(COMMAND_ARGS),docker-phpfpm)
	@npm run linter-docker $$(find images/phpfpm -name "Dockerfile")
else ifeq ($(COMMAND_ARGS),dockerfile)
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
	@echo "dockerfile: linter docker"
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
	@docker push koromerzhin/django -a
else ifeq ($(COMMAND_ARGS),nodejs)
	@docker push koromerzhin/nodejs -a
else ifeq ($(COMMAND_ARGS),phpfpm)
	@docker push koromerzhin/phpfpm -a
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