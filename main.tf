module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.0.0"

  function_name          = "slack-bolt-app"
  description            = "Slack bolt lambda function"
  handler                = "lambda.handler.lambda_handler"
  runtime                = "python3.10"
  create_package         = false
  local_existing_package = "build/lambda.zip"
  tracing_mode           = "Active"
}
