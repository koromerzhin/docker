
NODEJS_SUPPORTED_COMMANDS := generate-nodejs latest-nodejs

NODEJS_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(NODEJS_SUPPORTED_COMMANDS))
ifneq "$(NODEJS_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_NODEJS = $(call array_arguments, \
		["15.1.0"]=" v15.1.0" \
	)

.PHONY: generate-nodejs
generate-nodejs: isdocker ## generate nodejs
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-nodejs"
	$(DOCKER_NODEJS)
else
	@docker build -t koromerzhin/nodejs:${COMMANDS_ARGS} images/nodejs/${COMMANDS_ARGS} --target build-nodejs-${COMMANDS_ARGS}
endif

.PHONY: latest-nodejs
latest-nodejs: isdocker ## latest nodejs
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "latest-nodejs"
	$(DOCKER_NODEJS)
else
	@docker image tag koromerzhin/nodejs:${COMMANDS_ARGS}-nodejs koromerzhin/nodejs:latest
endif