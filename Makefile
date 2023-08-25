all: format lint tf-init tf-apply

format:
	terraform fmt -recursive
	black lambda

lint: 
	tflint --recursive
	flake8 lambda
	mypy lambda
	pylint lambda
	tfsec

clean:
	rm -rf build

build: clean
	mkdir -p build
	zip -r build/lambda.zip lambda

tf-init:
	terraform init -backend-config=backend.conf

tf-plan:
	terraform plan

tf-apply:
	terraform apply

tf-deploy: build tf-init tf-apply