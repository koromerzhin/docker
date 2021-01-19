ARGS := $(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL := help
%:
	@:

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

package-lock.json: package.json
	npm install

node_modules: package-lock.json
	npm install

install: node_modules ## Installation application

contributors: ## Contributors
	@npm run contributors

contributors-add: ## add Contributors
	@npm run contributors add

contributors-check: ## check Contributors
	@npm run contributors check

contributors-generate: ## generate Contributors
	@npm run contributors generate

git-commit: ## Commit data
	npm run commit

git-check: ## CHECK before
	@make contributors-check -i
	@git status

docker-images: ## docker images
	docker images

docker-generate: ## docker generate image
	@make docker-generate-django -i
	@make docker-generate-nodejs -i
	@make docker-generate-phpfpm -i

docker-generate-django: ## Docker GENERATE django
	docker build -t koromerzhin/django:latest images/django
	docker image tag koromerzhin/django:latest koromerzhin/django:3.9.0

docker-generate-nodejs: ## Docker GENERATE nodejs
	docker build -t koromerzhin/nodejs:latest images/nodejs
	docker image tag koromerzhin/nodejs:latest koromerzhin/nodejs:15.1.0
	docker build -t koromerzhin/nodejs:latest-angular images/nodejs/angular
	docker image tag koromerzhin/nodejs:latest-angular koromerzhin/nodejs:10.2.0-angular
	docker build -t koromerzhin/nodejs:latest-react images/nodejs/react
	docker image tag koromerzhin/nodejs:latest-react koromerzhin/nodejs:16.13.1-react
	docker build -t koromerzhin/nodejs:latest-sveltejs images/nodejs/sveltejs
	docker image tag koromerzhin/nodejs:latest-sveltejs koromerzhin/nodejs:3.29.4-sveltejs
	docker build -t koromerzhin/nodejs:latest-vuejs images/nodejs/vuejs
	docker image tag koromerzhin/nodejs:latest-vuejs koromerzhin/nodejs:4.5.8-vuejs
	docker build -t koromerzhin/nodejs:latest-quasar images/nodejs/quasar
	docker image tag koromerzhin/nodejs:latest-quasar koromerzhin/nodejs:1.1.3-quasar

docker-generate-phpfpm: ## Docker GENERATE phpfpm
	docker build -t koromerzhin/phpfpm:latest images/phpfpm
	docker image tag koromerzhin/phpfpm:latest koromerzhin/phpfpm:7.4.12
	docker build -t koromerzhin/phpfpm:latest-xdebug images/phpfpm/xdebug
	docker image tag koromerzhin/phpfpm:latest-xdebug koromerzhin/phpfpm:7.4.12-xdebug
	docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm/symfony
	docker image tag koromerzhin/phpfpm:latest-symfony koromerzhin/phpfpm:7.4.12-symfony
	docker build -t koromerzhin/phpfpm:latest-symfony-xdebug images/phpfpm/symfony-xdebug
	docker image tag koromerzhin/phpfpm:latest-symfony-xdebug koromerzhin/phpfpm:7.4.12-symfony-xdebug

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

linter-docker-nodejs: ## linter docker nodejs
	@npm run linter-docker images/nodejs/Dockerfile
	@npm run linter-docker images/nodejs/*/Dockerfile

linter-docker-django: ## linter docker django
	@npm run linter-docker images/django/Dockerfile

linter-docker-phpfpm: ## linter docker phpfpm
	@npm run linter-docker images/phpfpm/Dockerfile
	@npm run linter-docker images/phpfpm/*/Dockerfile

linter-readme: ## linter README
	@npm run linter-markdown README.md

linter-docker: ## linter docker
	@make linter-docker-nodejs -i
	@make linter-docker-django -i
	@make linter-docker-phpfpm -i