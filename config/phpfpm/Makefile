
PHP_SUPPORTED_COMMANDS := generate-phpfpm latest-phpfpm

PHP_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(PHP_SUPPORTED_COMMANDS))
ifneq "$(PHP_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_PHPFPM = $(call array_arguments, \
		["5.6.40"]=" v5.6.40" \
		["7.4.33"]=" v7.4.33" \
		["8.0.15"]=" v8.0.15" \
		["8.1.12"]=" v8.1.12" \
	)

.PHONY: generate-phpfpm
generate-phpfpm: isdocker ## generate phpfpm
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-phpfpm"
	$(DOCKER_PHPFPM)
else
	@docker build -t koromerzhin/phpfpm:${COMMANDS_ARGS} images/phpfpm/${COMMANDS_ARGS} --target build-phpfpm-${COMMANDS_ARGS}
	@docker build -t koromerzhin/phpfpm:${COMMANDS_ARGS}-xdebug images/phpfpm/${COMMANDS_ARGS} --target build-phpfpm-xdebug-${COMMANDS_ARGS}
endif

.PHONY: latest-phpfpm
latest-phpfpm: isdocker ## latest phpfpm
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "latest-phpfpm"
	$(DOCKER_PHPFPM)
else
	@docker image tag koromerzhin/phpfpm:${COMMANDS_ARGS} koromerzhin/phpfpm:latest
	@docker image tag koromerzhin/phpfpm:${COMMANDS_ARGS}-xdebug koromerzhin/phpfpm:latest-xdebug
endif
