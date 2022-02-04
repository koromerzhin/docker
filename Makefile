include make/general/Makefile
include make/docker/Makefile
include config/phpfpm/Makefile
include config/django/Makefile
include config/nodejs/Makefile
include config/nodejs/angular/Makefile
include config/nodejs/quasar/Makefile
include config/nodejs/remotion/Makefile

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