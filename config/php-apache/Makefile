
PHP_SUPPORTED_COMMANDS := generate-php-apache latest-php-apache

PHP_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(PHP_SUPPORTED_COMMANDS))
ifneq "$(PHP_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_php-apache = $(call array_arguments, \
		["5.6.40"]=" v5.6.40" \
		["7.4.33"]=" v7.4.33" \
		["8.0.15"]=" v8.0.15" \
		["8.1.13"]=" v8.1.13" \
		["8.2.0"]=" v8.2.0" \
	)

.PHONY: generate-php-apache
generate-php-apache: isdocker ## generate php-apache
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-php-apache"
	$(DOCKER_php-apache)
else
	@docker build -t koromerzhin/php-apache:${COMMANDS_ARGS} images/php-apache/${COMMANDS_ARGS} --target build-php-apache-${COMMANDS_ARGS}
	@docker build -t koromerzhin/php-apache:${COMMANDS_ARGS}-xdebug images/php-apache/${COMMANDS_ARGS} --target build-php-apache-xdebug-${COMMANDS_ARGS}
endif

.PHONY: latest-php-apache
latest-php-apache: isdocker ## latest php-apache
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "latest-php-apache"
	$(DOCKER_php-apache)
else
	@docker image tag koromerzhin/php-apache:${COMMANDS_ARGS} koromerzhin/php-apache:latest
	@docker image tag koromerzhin/php-apache:${COMMANDS_ARGS}-xdebug koromerzhin/php-apache:latest-xdebug
endif
