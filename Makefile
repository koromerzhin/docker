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

docker-generate-php-fpm: ## Docker GENERATE php-fpm
	docker build -t koromerzhin/php-fpm:latest images/php-fpm

docker-generate-php-fpm-symfony: ## Docker GENERATE php-fpm-symfony
	docker build -t koromerzhin/php-fpm-symfony:latest images/php-fpm-symfony

docker-generate-vuejs: ## Docker GENERATE vuejs
	docker build -t koromerzhin/vuejs:latest images/vuejs

docker-login: ## Login docker
	docker login

docker-push-angular: ## Docker PUSH angular
	@echo "docker push koromerzhin/angular:latest"

docker-push-php-fpm: ## Docker PUSH php-fpm
	@echo "docker push koromerzhin/php-fpm:latest"

docker-push-php-fpm-symfony: ## Docker PUSH php-fpm-symfony
	@echo "docker push koromerzhin/php-fpm-symfony:latest"

docker-push-vuejs: ## Docker PUSH vuejs
	@echo "docker push koromerzhin/vuejs:latest"