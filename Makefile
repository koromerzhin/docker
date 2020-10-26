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

docker-generate-phpfpm-without-xdebug: ## Docker GENERATE phpfpm without xdebug
	docker build -t koromerzhin/phpfpm-without-xdebug:latest images/phpfpm-without-xdebug

docker-generate-php-fpm-symfony: ## Docker GENERATE php-fpm-symfony
	docker build -t koromerzhin/php-fpm-symfony:latest images/php-fpm-symfony

docker-generate-php-fpm-symfony-without-xdebug: ## Docker GENERATE php-fpm-symfony without xdebug
	docker build -t koromerzhin/php-fpm-symfony-without-xdebug:latest images/php-fpm-symfony-without-xdebug

docker-generate-vuejs: ## Docker GENERATE vuejs
	docker build -t koromerzhin/vuejs:latest images/vuejs

docker-generate-react: ## Docker GENERATE react
	docker build -t koromerzhin/react:latest images/react

docker-generate-django: ## Docker GENERATE django
	docker build -t koromerzhin/django:latest images/django

docker-login: ## Login docker
	docker login

docker-push-angular: ## Docker PUSH angular
	@echo "docker push koromerzhin/angular:latest"

docker-push-phpfpm: ## Docker PUSH phpfpm
	@echo "docker push koromerzhin/phpfpm:latest"

docker-push-phpfpm-without-xdebug: ## Docker PUSH phpfpm-without-xdebug
	@echo "docker push koromerzhin/phpfpm-without-xdebug:latest"

docker-push-php-fpm-symfony: ## Docker PUSH php-fpm-symfony
	@echo "docker push koromerzhin/php-fpm-symfony:latest"

docker-push-php-fpm-symfony-without-xdebug: ## Docker PUSH php-fpm-symfony-without-xdebug
	@echo "docker push koromerzhin/php-fpm-symfony-without-xdebug:latest"

docker-push-vuejs: ## Docker PUSH vuejs
	@echo "docker push koromerzhin/vuejs:latest"

docker-push-react: ## Docker PUSH react
	@echo "docker push koromerzhin/react:latest"

docker-push-django: ## Docker PUSH django
	@echo "docker push koromerzhin/django:latest"