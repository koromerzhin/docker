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

docker-generate: ## docker generate image
	@make docker-generate-django -i
	@make docker-generate-nodejs -i
	@make docker-generate-phpfpm -i

docker-generate-django: ## Docker GENERATE django
	docker build -t koromerzhin/django:latest images/django/3.9.0
	docker build -t koromerzhin/django:3.9.0 images/django/3.9.0

docker-generate-nodejs: ## Docker GENERATE nodejs
	docker build -t koromerzhin/nodejs:latest images/nodejs/15.0.1
	docker build -t koromerzhin/nodejs:15.0.1 images/nodejs/15.0.1
	docker build -t koromerzhin/nodejs:latest-angular images/nodejs/angular/10.2.0
	docker build -t koromerzhin/nodejs:10.2.0-angular images/nodejs/angular/10.2.0
	docker build -t koromerzhin/nodejs:latest-react images/nodejs/react/15.0.1
	docker build -t koromerzhin/nodejs:15.0.1-react images/nodejs/react/15.0.1
	docker build -t koromerzhin/nodejs:latest-sveltejs images/nodejs/sveltejs/15.0.1
	docker build -t koromerzhin/nodejs:15.0.1-sveltejs images/nodejs/sveltejs/15.0.1
	docker build -t koromerzhin/nodejs:latest-vuejs images/nodejs/vuejs/4.5.8
	docker build -t koromerzhin/nodejs:4.5.8-vuejs images/nodejs/vuejs/4.5.8

docker-generate-phpfpm: ## Docker GENERATE phpfpm
	docker build -t koromerzhin/phpfpm:latest images/phpfpm/7.4.12
	docker build -t koromerzhin/phpfpm:7.4.12 images/phpfpm/7.4.12
	docker build -t koromerzhin/phpfpm:latest-xdebug images/phpfpm/xdebug/7.4.12
	docker build -t koromerzhin/phpfpm:7.4.12-xdebug images/phpfpm/xdebug/7.4.12
	docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm/symfony/7.4.12
	docker build -t koromerzhin/phpfpm:7.4.12-symfony images/phpfpm/symfony/7.4.12
	docker build -t koromerzhin/phpfpm:latest-symfony-xdebug images/phpfpm/symfony-xdebug/7.4.12
	docker build -t koromerzhin/phpfpm:7.4.12-symfony-xdebug images/phpfpm/symfony-xdebug/7.4.12

docker-login: ## Login docker
	docker login

docker-push: ## docker PUSH
	@make docker-push-django -i
	@make docker-push-nodejs -i
	@make docker-push-phpfpm -i

docker-push-django: ## Docker PUSH django
	docker push koromerzhin/django

docker-push-nodejs: ## Docker PUSH nodejs
	docker push koromerzhin/nodejs

docker-push-phpfpm: ## Docker PUSH phpfpm
	docker push koromerzhin/phpfpm

linter-docker-nodejs: node_modules ## linter docker nodejs
	@npm run linter-docker images/nodejs/*/Dockerfile
	@npm run linter-docker images/nodejs/*/*/Dockerfile

linter-docker-django: node_modules ## linter docker django
	@npm run linter-docker images/django/*/Dockerfile

linter-docker-phpfpm: node_modules ## linter docker phpfpm
	@npm run linter-docker images/phpfpm/*/Dockerfile
	@npm run linter-docker images/phpfpm/*/*/Dockerfile

linter-readme: node_modules ## linter README
	@npm run linter-markdown README.md

linter-docker: node_modules ## linter docker
	@make linter-docker-nodejs -i
	@make linter-docker-django -i
	@make linter-docker-phpfpm -i