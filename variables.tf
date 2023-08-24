variable "aws_region" {
  description = "The AWS region to create the infrastructure in"
  type        = string
  default     = "us-east-1"
}

variable "terraform_state_bucket" {
  description = "The AWS S3 bucket that is used for storing state.  This must be create before terraform init."
  type        = string
  default     = "terraform-state-bucket"
}

variable "terraform_state_key" {
  description = "The S3 key to the location of the terraform state"
  type        = string
  default     = "tfstate/slack-bolt-lambda-app.tfstate"
}
