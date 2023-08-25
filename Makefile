include ./.env

init:
	pip install -r lambda/requirements.txt

all: format lint tf-deploy

format:
	terraform fmt -recursive
	black lambda

lint: 
	tflint --recursive
	flake8 lambda
	mypy lambda
	pylint lambda --rcfile .pylintrc
	tfsec

clean:
	rm -rf build

build: clean
	mkdir -p build/lambda
	pip install -r lambda/requirements.txt --target ./build/lambda
	cp lambda/*.py build/lambda
	cd build/lambda && zip -r ../lambda.zip .

tf-init:
	terraform init -backend-config=backend.conf

tf-plan:
	terraform plan -var=slack_signing_secret=$(SLACK_SIGNING_SECRET) -var=slack_bot_token=$(SLACK_BOT_TOKEN)

tf-apply:
	terraform apply -var=slack_signing_secret=$(SLACK_SIGNING_SECRET) -var=slack_bot_token=$(SLACK_BOT_TOKEN)

tf-deploy: build tf-init tf-apply