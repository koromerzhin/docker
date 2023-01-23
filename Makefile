include make/general/Makefile
include make/docker/Makefile
include config/phpfpm/Makefile
include config/php-apache/Makefile
include config/django/Makefile

COMMANDS_SUPPORTED_COMMANDS := linter push

COMMANDS_SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(COMMANDS_SUPPORTED_COMMANDS))
ifneq "$(COMMANDS_SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif
install: node_modules ## Installation application

.PHONY: linter
linter: node_modules ### Scripts Linter
ifeq ($(COMMANDS_ARGS),all)
	@make linter readme -i
	@make linter dockerfile -i
else ifeq ($(COMMANDS_ARGS),readme)
	@npm run linter-markdown README.md
else ifeq ($(COMMANDS_ARGS),django)
	@npm run linter-docker $$(find images/django -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),phpfpm)
	@npm run linter-docker $$(find images/phpfpm -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),php-apache)
	@npm run linter-docker $$(find images/php-apache -name "Dockerfile")
else ifeq ($(COMMANDS_ARGS),dockerfile)
	@make linter django -i
	@make linter phpfpm -i
	@make linter php-apache -i
else
	@printf "${MISSING_ARGUMENTS}" "linter"
	$(call array_arguments, \
		["all"]="all" \
		["readme"]="linter README.md" \
		["dockerfile"]="linter docker all " \
		["phpfpm"]="linter docker phpfpm" \
		["php-apache"]="linter docker php-apache" \
	)
endif

.PHONY: push
push: isdocker ### push image
ifeq ($(COMMANDS_ARGS),)
	$(call array_arguments, \
		["angular"]="push all angular images" \
		["django"]="push all django images" \
		["phpfpm"]="push all phpfpm images" \
		["php-apache"]="push all php-apache images" \
		["quasar"]="push all quasar images" \
	)
else
	@docker push koromerzhin/${COMMANDS_ARGS} -a
endif
