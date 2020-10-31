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
	@make docker-generate-angular -i
	@make docker-generate-django -i
	@make docker-generate-phpfpm -i
	@make docker-generate-react -i
	@make docker-generate-sveltejs -i
	@make docker-generate-vuejs -i

docker-generate-angular: ## Docker GENERATE angular
	docker build -t koromerzhin/angular:latest images/angular

docker-generate-django: ## Docker GENERATE django
	docker build -t koromerzhin/django:latest images/django

docker-generate-phpfpm: ## Docker GENERATE phpfpm
	docker build -t koromerzhin/phpfpm:latest images/phpfpm
	docker build -t koromerzhin/phpfpm:latest-without-xdebug images/phpfpm-without-xdebug
	docker build -t koromerzhin/phpfpm:latest-symfony images/phpfpm-symfony
	docker build -t koromerzhin/phpfpm:latest-symfony-without-xdebug images/phpfpm-symfony-without-xdebug

docker-generate-react: ## Docker GENERATE react
	docker build -t koromerzhin/react:latest images/react

docker-generate-sveltejs: ## Docker GENERATE sveltejs
	docker build -t koromerzhin/sveltejs:latest images/sveltejs

docker-generate-vuejs: ## Docker GENERATE vuejs
	docker build -t koromerzhin/vuejs:latest images/vuejs

docker-login: ## Login docker
	docker login

docker-push-angular: ## Docker PUSH angular
	@make docker-images -i
	@echo "docker push koromerzhin/angular"

docker-push-django: ## Docker PUSH django
	@make docker-images -i
	@echo "docker push koromerzhin/django"

docker-push-phpfpm: ## Docker PUSH phpfpm
	@make docker-images -i
	@echo "docker push koromerzhin/phpfpm"

docker-push-react: ## Docker PUSH react
	@make docker-images -i
	@echo "docker push koromerzhin/react"

docker-push-sveltejs: ## Docker PUSH sveltejs
	@make docker-images -i
	@echo "docker push koromerzhin/sveltejs"

docker-push-vuejs: ## Docker PUSH vuejs
	@make docker-images -i
	@echo "docker push koromerzhin/vuejs"


linter-docker-angular: node_modules ## linter docker angular
	@npm run linter-docker images/angular/Dockerfile
linter-docker-django: node_modules ## linter docker django
	@npm run linter-docker images/django/Dockerfile
linter-docker-phpfpm: node_modules ## linter docker phpfpm
	@npm run linter-docker images/phpfpm/Dockerfile
linter-docker-phpfpm-without-xdebug: node_modules ## linter docker phpfpm-without-xdebug
	@npm run linter-docker images/phpfpm-without-xdebug/Dockerfile
linter-docker-phpfpm-symfony: node_modules ## linter docker phpfpm-symfony
	@npm run linter-docker images/phpfpm-symfony/Dockerfile
linter-docker-phpfpm-symfony-without-xdebug: node_modules ## linter docker phpfpm-symfony-without-xdebug
	@npm run linter-docker images/phpfpm-symfony-without-xdebug/Dockerfile
linter-docker-react: node_modules ## linter react
	@npm run linter-docker images/react/Dockerfile
linter-docker-sveltejs: node_modules ## linter sveltejs
	@npm run linter-docker images/sveltejs/Dockerfile
linter-docker-vuejs: node_modules ## linter vuejs
	@npm run linter-docker images/vuejs/Dockerfile

linter-readme: node_modules ## linter README
	@npm run linter-markdown README.md

linter-docker: node_modules ## linter docker
	@make linter-docker-angular -i
	@make linter-docker-django -i
	@make linter-docker-phpfpm -i
	@make linter-docker-phpfpm-without-xdebug -i
	@make linter-docker-phpfpm-symfony -i
	@make linter-docker-phpfpm-symfony-without-xdebug -i
	@make linter-docker-react -i
	@make linter-docker-sveltejs -i
	@make linter-docker-vuejs -i