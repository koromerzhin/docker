
DJANGO_SUPPORTED_COMMANDS := generate-django latest-django

DJANGO_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(DJANGO_SUPPORTED_COMMANDS))
ifneq "$(DJANGO_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

DOCKER_DJANGO = $(call array_arguments, \
		["all"]="generate all django images" \
		["2.2.27"]=" v2.2.27" \
		["3.2.12"]=" v3.2.12" \
		["4.0.2"]=" v4.0.2" \
	)

.PHONY: generate-django
generate-django: isdocker ## Generate django
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "generate-django"
	$(DOCKER_DJANGO)
else ifeq ($(COMMANDS_ARGS),all)
	@make generate-django 3.9.0
else
	@docker build -t koromerzhin/django:${COMMANDS_ARGS} images/python/django/${COMMANDS_ARGS} --target build-django-${COMMANDS_ARGS}
endif

.PHONY: latest-django
latest-django: isdocker ## latest django
ifeq ($(COMMANDS_ARGS),)
	@printf "${MISSING_ARGUMENTS}" "latest-django"
	$(DOCKER_DJANGO)
else
	@docker image tag koromerzhin/django:${COMMANDS_ARGS} koromerzhin/django:latest
endif
