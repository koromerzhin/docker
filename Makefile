ARGS := $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := help
%:
	@:

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

node_modules:
	npm install

install: node_modules ## Installation application

contributors-add: node_modules ## add Contributors
	@npm run contributors add

contributors-check: node_modules ## check Contributors
	@npm run contributors check

contributors-generate: node_modules ## generate Contributors
	@npm run contributors generate

git-commit: node_modules ## Commit data
	npm run commit

git-check: node_modules ## CHECK before
	@make contributors-check -i
	@git status

docker-images: ## docker images
	docker images

docker-generate-angular: ## Docker GENERATE angular
	docker build -t koromerzhin/angular:latest images/angular

docker-generate-phpfpm: ## Docker GENERATE phpfpm
	docker build -t koromerzhin/phpfpm:latest images/phpfpm
	docker build -t koromerzhin/phpfpm:latest-without-xdebug images/phpfpm-without-xdebug
	docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm-symfony
	docker build -t koromerzhin/phpfpm:latest-symfony-without-xdebug images/phpfpm-symfony-without-xdebug

docker-generate-vuejs: ## Docker GENERATE vuejs
	docker build -t koromerzhin/vuejs:latest images/vuejs

docker-generate-react: ## Docker GENERATE react
	docker build -t koromerzhin/react:latest images/react

docker-generate-django: ## Docker GENERATE django
	docker build -t koromerzhin/django:latest images/django

docker-login: ## Login docker
	docker login

docker-push-angular: ## Docker PUSH angular
	@make docker-images -i
	@echo "docker push koromerzhin/angular"

docker-push-phpfpm: ## Docker PUSH phpfpm
	@make docker-images -i
	@echo "docker push koromerzhin/phpfpm"

docker-push-vuejs: ## Docker PUSH vuejs
	@make docker-images -i
	@echo "docker push koromerzhin/vuejs"

docker-push-react: ## Docker PUSH react
	@make docker-images -i
	@echo "docker push koromerzhin/react"

docker-push-django: ## Docker PUSH django
	@make docker-images -i
	@echo "docker push koromerzhin/django"