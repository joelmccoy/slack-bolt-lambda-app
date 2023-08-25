variable "lambda_code_bucket_name" {
  description = "The name of the s3 bucket that should be created to store the lambda zip."
  type        = string
  default     = "slack-bolt-lambda-app"
}