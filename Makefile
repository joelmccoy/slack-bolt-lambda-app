all: format lint

format:
	terraform fmt -recursive

lint: 
	tflint --recursive

tf-init:
	terraform init -backend-config=backend.conf

tf-plan:
	terraform plan

tf-apply:
	terraform apply

tf-deploy: tf-init tf-apply