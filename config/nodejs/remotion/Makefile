
REMOTION_SUPPORTED_COMMANDS := generate-remotion latest-remotion

REMOTION_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(REMOTION_SUPPORTED_COMMANDS))
ifneq "$(REMOTION_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_REMOTION = $(call array_arguments, \
		["1.3.0"]=" v1.3.0" \
	)

.PHONY: generate-remotion
generate-remotion: isdocker
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-remotion"
	$(DOCKER_REMOTION)
else
	@docker build -t koromerzhin/remotion:${COMMANDS_ARGS} images/nodejs/remotion/${COMMANDS_ARGS} --target build-remotion-${COMMANDS_ARGS}
endif

.PHONY: latest-remotion
latest-remotion: isdocker
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "latest-remotion"
	$(DOCKER_REMOTION)
else
	@docker image tag koromerzhin/nodejs:${COMMANDS_ARGS}-remotion koromerzhin/remotion:latest
endif