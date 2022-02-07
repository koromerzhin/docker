
NODEJS_SUPPORTED_COMMANDS := generate-nodejs latest-nodejs

NODEJS_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(NODEJS_SUPPORTED_COMMANDS))
ifneq "$(NODEJS_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_NODEJS = $(call array_arguments, \
		["4.9.1"]=" v4.9.1" \
		["5.12.0"]=" v5.12.0" \
		["6.17.1"]=" v6.17.1" \
		["7.10.1"]=" v7.10.1" \
		["8.17.0"]=" v8.17.0" \
		["9.11.2"]=" v9.11.2" \
		["10.24.1"]=" v10.24.1" \
		["11.15.0"]=" v11.15.0" \
		["12.22.10"]=" v12.22.10" \
		["13.14.0"]=" v13.14.0" \
		["14.19.0"]=" v14.19.0" \
		["15.14.0"]=" v15.14.0" \
		["16.13.2"]=" v16.13.2" \
		["17.4.0"]=" v17.4.0" \
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
	@docker image tag koromerzhin/nodejs:${COMMANDS_ARGS} koromerzhin/nodejs:latest
endif
