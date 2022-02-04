
QUASAR_SUPPORTED_COMMANDS := generate-quasar latest-quasar

QUASAR_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(QUASAR_SUPPORTED_COMMANDS))
ifneq "$(QUASAR_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_QUASAR = $(call array_arguments, \
		["1.1.3"]=" v1.1.3" \
	)

.PHONY: generate-quasar
generate-quasar: isdocker ## generate quasar
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-quasar"
	$(DOCKER_QUASAR)
else
	@docker build -t koromerzhin/quasar:${COMMANDS_ARGS} images/nodejs/quasar/${COMMANDS_ARGS} --target build-quasar-${COMMANDS_ARGS}
endif

.PHONY: latest-quasar
latest-quasar: isdocker ## latest quasar
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "latest-quasar"
	$(DOCKER_QUASAR)
else
	@docker image tag koromerzhin/quasar:${COMMANDS_ARGS} koromerzhin/quasar:latest
endif