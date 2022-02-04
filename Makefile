include make/general/Makefile
include make/docker/Makefile

COMMANDS_SUPPORTED_COMMANDS := generate linter push generate-phpfpm generate-django
COMMANDS_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(COMMANDS_SUPPORTED_COMMANDS))
ifneq "$(COMMANDS_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

install: node_modules ## Installation application

.PHONY: generate
generate: isdocker ### Generate image
ifeq ($(COMMANDS_ARGS),all)
	@make generate nodejs -i
else ifeq ($(COMMANDS_ARGS),nodejs)
	@make generate nodejs-nodejs -i
	@make generate nodejs-angular -i
	@make generate nodejs-remotion -i
	@make generate nodejs-quasar -i
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
else
	@printf "${MISSING_ARGUMENTS}" generate
	$(call array_arguments, \
		["all"]="generate all images" \
		["nodejs"]="generate all nodejs images" \
		["nodejs-nodejs"]="generate nodejs" \
		["nodejs-express"]="generate express" \
		["nodejs-socketio"]="generate socketio" \
		["nodejs-angular"]="generate angular" \
		["nodejs-remotion"]="generate remotion" \
		["nodejs-react"]="generate react" \
		["nodejs-sveltejs"]="generate sveltejs" \
		["nodejs-vuejs"]="generate vuejs" \
		["nodejs-quasar"]="generate quasar" \
	)
endif

.PHONY: linter
linter: node_modules ### Scripts Linter
ifeq ($(COMMANDS_ARGS),all)
	@make linter readme -i
	@make linter dockerfile -i
else ifeq ($(COMMANDS_ARGS),readme)
	@npm run linter-markdown README.md
else ifeq ($(COMMANDS_ARGS),nodejs)
	@npm run linter-docker $$(find images/nodejs -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),python)
	@npm run linter-docker $$(find images/python -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),phpfpm)
	@npm run linter-docker $$(find images/phpfpm -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),dockerfile)
	@make linter nodejs -i
	@make linter python -i
	@make linter phpfpm -i
else
	@printf "${MISSING_ARGUMENTS}" "linter"
	$(call array_arguments, \
		["all"]="all" \
		["readme"]="linter README.md" \
		["dockerfile"]="linter docker all " \
		["nodejs"]="linter docker nodejs" \
		["phpfpm"]="linter docker phpfpm" \
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

.PHONY: generate-django
generate-django: isdocker
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-django"
	$(call array_arguments, \
		["all"]="generate all django images" \
		["3.9.0"]=" v3.9.0" \
	)
else ifeq ($(COMMANDS_ARGS),all)
	@make generate-django 3.9.0
else
	@docker build -t koromerzhin/django:${COMMANDS_ARGS} images/django/${COMMANDS_ARGS} --target build-django-${COMMANDS_ARGS}
	ifeq ($(COMMANDS_ARGS),"3.9.0")
		@docker image tag koromerzhin/django:${COMMANDS_ARGS} koromerzhin/django:latest
	endif
endif

.PHONY: generate-phpfpm
generate-phpfpm: isdocker
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-phpfpm"
	$(call array_arguments, \
		["all"]="generate all phpfpm images" \
		["7.4.12"]=" v7.4.12" \
		["8.0.15"]=" v8.0.15" \
		["8.1.2"]=" v8.1.2" \
	)
else ifeq ($(COMMANDS_ARGS),all)
	@make generate-phpfpm 7.4.12
	@make generate-phpfpm 8.0.15
	@make generate-phpfpm 8.1.2
else
	@docker build -t koromerzhin/phpfpm:${COMMANDS_ARGS} images/phpfpm/${COMMANDS_ARGS} --target build-phpfpm-${COMMANDS_ARGS}
	@docker build -t koromerzhin/phpfpm:${COMMANDS_ARGS}-xdebug images/phpfpm/${COMMANDS_ARGS} --target build-phpfpm-xdebug-${COMMANDS_ARGS}
	ifeq ($(COMMANDS_ARGS),"8.1.2")
		@docker image tag koromerzhin/phpfpm:${COMMANDS_ARGS} koromerzhin/phpfpm:latest
		@docker image tag koromerzhin/phpfpm:${COMMANDS_ARGS}-xdebug koromerzhin/phpfpm:latest-xdebug
	endif
endif