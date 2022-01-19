include make/general/Makefile
include make/docker/Makefile

COMMANDS_SUPPORTED_COMMANDS := docker-generate linter push
COMMANDS_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(COMMANDS_SUPPORTED_COMMANDS))
ifneq "$(COMMANDS_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

install: node_modules ## Installation application

.PHONY: docker-generate
docker-generate: isdocker ### Generate image
ifeq ($(COMMANDS_ARGS),all)
	@make docker-generate python -i
	@make docker-generate nodejs -i
	@make docker-generate phpfpm -i
else ifeq ($(COMMANDS_ARGS),python)
	@docker build -t koromerzhin/django:latest images/python --target build-django-3.9.0
	@docker image tag koromerzhin/django:latest koromerzhin/django:3.9.0
else ifeq ($(COMMANDS_ARGS),nodejs)
	@make docker-generate nodejs-nodejs -i
	@make docker-generate nodejs-angular -i
	@make docker-generate nodejs-remotion -i
	@make docker-generate nodejs-quasar -i
else ifeq ($(COMMANDS_ARGS),nodejs-nodejs)
	@echo "Generate Nodejs"
	@docker build -t koromerzhin/nodejs:latest images/nodejs --target build-nodejs-15.1.0
	@docker image tag koromerzhin/nodejs:latest koromerzhin/nodejs:15.1.0
else ifeq ($(COMMANDS_ARGS),nodejs-angular)
	@echo "Generate angular"
	@docker build -t koromerzhin/nodejs:latest-angular images/nodejs --target build-angular-10.2.0
	@docker image tag koromerzhin/nodejs:latest-angular koromerzhin/nodejs:10.2.0-angular
else ifeq ($(COMMANDS_ARGS),nodejs-remotion)
	@echo "Generate Remotion"
	@docker build -t koromerzhin/nodejs:latest-remotion images/nodejs --target build-remotion-1.3.0
	@docker image tag koromerzhin/nodejs:latest-remotion koromerzhin/nodejs:1.3.0-remotion
else ifeq ($(COMMANDS_ARGS),nodejs-quasar)
	@echo "Generate Quarsar"
	@docker build -t koromerzhin/nodejs:latest-quasar images/nodejs --target build-quasar-1.1.3
	@docker image tag koromerzhin/nodejs:latest-quasar koromerzhin/nodejs:1.1.3-quasar
else ifeq ($(COMMANDS_ARGS),phpfpm)
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
else ifeq ($(COMMANDS_ARGS),phpfpm-phpfpm)
	@echo "Generate PHPFPM"
	@docker build -t koromerzhin/phpfpm:latest images/phpfpm --target build-phpfpm-8.0.9
	@docker image tag koromerzhin/phpfpm:latest koromerzhin/phpfpm:8.0.9
else ifeq ($(COMMANDS_ARGS),phpfpm-xdebug)
	@echo "Generate XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-xdebug images/phpfpm --target build-phpfpm-xdebug-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-xdebug koromerzhin/phpfpm:8.0.9-xdebug
else ifeq ($(COMMANDS_ARGS),phpfpm-symfony)
	@echo "Generate Symfony"
	@docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm --target build-phpfpm-symfony-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-symfony koromerzhin/phpfpm:8.0.9-symfony
else ifeq ($(COMMANDS_ARGS),phpfpm-symfony-xdebug)
	@echo "Generate Symfony XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-symfony-xdebug images/phpfpm --target build-phpfpm-symfony-xdebug-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-symfony-xdebug koromerzhin/phpfpm:8.0.9-symfony-xdebug
else ifeq ($(COMMANDS_ARGS),phpfpm-all)
	@echo "Generate all"
	@docker build -t koromerzhin/phpfpm:latest-all images/phpfpm --target build-phpfpm-all-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-all koromerzhin/phpfpm:8.0.9-all
else ifeq ($(COMMANDS_ARGS),phpfpm-all-xdebug)
	@echo "Generate all XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-all-xdebug images/phpfpm --target build-phpfpm-all-xdebug-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-all-xdebug koromerzhin/phpfpm:8.0.9-all-xdebug
else ifeq ($(COMMANDS_ARGS),phpfpm-drupal)
	@echo "Generate drupal"
	@docker build -t koromerzhin/phpfpm:latest-drupal images/phpfpm --target build-phpfpm-drupal-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-drupal koromerzhin/phpfpm:8.0.9-drupal
else ifeq ($(COMMANDS_ARGS),phpfpm-drupal-xdebug)
	@echo "Generate drupal XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-drupal-xdebug images/phpfpm --target build-phpfpm-drupal-xdebug-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-drupal-xdebug koromerzhin/phpfpm:8.0.9-drupal-xdebug
else ifeq ($(COMMANDS_ARGS),phpfpm-wordpress)
	@echo "Generate wordpress"
	@docker build -t koromerzhin/phpfpm:latest-wordpress images/phpfpm --target build-phpfpm-wordpress-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-wordpress koromerzhin/phpfpm:8.0.9-wordpress
else ifeq ($(COMMANDS_ARGS),phpfpm-wordpress-xdebug)
	@echo "Generate wordpress XDEBUG"
	@docker build -t koromerzhin/phpfpm:latest-wordpress-xdebug images/phpfpm --target build-phpfpm-wordpress-xdebug-8.0.9
	@docker image tag koromerzhin/phpfpm:latest-wordpress-xdebug koromerzhin/phpfpm:8.0.9-wordpress-xdebug
else
	@printf "${MISSING_ARGUMENTS}" docker-generate
	$(call array_arguments, \
		["images"] ="images" \
		["check"] ="CHECK before" \
		["all"] ="generate all images" \
		["python"] ="generate all python images" \
		["nodejs"] ="generate all nodejs images" \
		["nodejs-nodejs"]="generate nodejs" \
		["nodejs-express"]="generate express" \
		["nodejs-socketio"]="generate socketio" \
		["nodejs-angular"]="generate angular" \
		["nodejs-remotion"]="generate remotion" \
		["nodejs-react"]="generate react" \
		["nodejs-sveltejs"]="generate sveltejs" \
		["nodejs-vuejs"]="generate vuejs" \
		["nodejs-quasar"]="generate quasar" \
		["phpfpm"]="generate all phpfpm images" \
		["phpfpm-all"]="generate phpfpm with symfony drupal" \
		["phpfpm-all-xdebug"]="generate phpfpm with symfony drupal xdebug" \
		["phpfpm-phpfpm"]="generate phpfpm" \
		["phpfpm-xdebug"]="generate xdebug" \
		["phpfpm-symfony"]="generate symfony" \
		["phpfpm-symfony-xdebug"]="generate symfony-xdebug" \
		["phpfpm-drupal"]="generate drupal" \
		["phpfpm-drupal-xdebug"]="generate drupal-xdebug" \
		["phpfpm-wordpress"]="generate wordpress" \
		["phpfpm-wordpress-xdebug"]="generate wordpress-xdebug" \
	)
endif

.PHONY: linter
linter: node_modules ### Scripts Linter
ifeq ($(COMMANDS_ARGS),all)
	@make linter readme -i
	@make linter docker-nodejs -i
	@make linter docker-python -i
	@make linter docker-phpfpm -i
else ifeq ($(COMMANDS_ARGS),readme)
	@npm run linter-markdown README.md
else ifeq ($(COMMANDS_ARGS),docker-nodejs)
	@npm run linter-docker $$(find images/nodejs -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),docker-python)
	@npm run linter-docker $$(find images/python -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),docker-phpfpm)
	@npm run linter-docker $$(find images/phpfpm -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),dockerfile)
	@make linter docker-nodejs -i
	@make linter docker-python -i
	@make linter docker-phpfpm -i
else
	@printf "${MISSING_ARGUMENTS}" "linter"
	$(call array_arguments, \
		["all"]="all" \
		["readme"]="linter README.md" \
		["dockerfile"]="linter docker" \
		["docker-python"]="linter docker python" \
		["docker-nodejs"]="linter docker nodejs" \
		["docker-phpfpm"]="linter docker phpfpm" \
	)
endif

.PHONY: push
push: isdocker ### push image
ifeq ($(COMMANDS_ARGS),all)
	@make push python
	@make push nodejs
	@make push phpfpm
else ifeq ($(COMMANDS_ARGS),python)
	@docker push koromerzhin/python -a
else ifeq ($(COMMANDS_ARGS),nodejs)
	@docker push koromerzhin/nodejs -a
else ifeq ($(COMMANDS_ARGS),phpfpm)
	@docker push koromerzhin/phpfpm -a
else
	@printf "${MISSING_ARGUMENTS}" "push"
	$(call array_arguments, \
		["all"]="push all images" \
		["python"]="push all python images" \
		["nodejs"]="push all nodejs images" \
		["phpfpm"]="push all phpfpm images" \
	)
endif