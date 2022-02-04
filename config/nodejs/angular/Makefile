
ANGULAR_SUPPORTED_COMMANDS := generate-angular latest-angular

ANGULAR_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(ANGULAR_SUPPORTED_COMMANDS))
ifneq "$(ANGULAR_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_ANGULAR = $(call array_arguments, \
		["10.2.4"]=" v10.2.4" \
		["11.2.18"]=" v11.2.18" \
		["12.2.16"]=" v12.2.16" \
		["13.2.2"]=" v13.2.2" \
	)

.PHONY: generate-angular
generate-angular: isdocker ## generate angular
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-angular"
	$(DOCKER_ANGULAR)
else
	@docker build -t koromerzhin/angular:${COMMANDS_ARGS} images/nodejs/angular/${COMMANDS_ARGS} --target build-angular-${COMMANDS_ARGS}
endif

.PHONY: latest-angular
latest-angular: isdocker ## latest angular
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "latest-angular"
	$(DOCKER_ANGULAR)
else
	@docker image tag koromerzhin/angular:${COMMANDS_ARGS} koromerzhin/angular:latest
endif
