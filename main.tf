data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
  aws_region = data.aws_region.this.name
}


data "aws_iam_policy_document" "allow_lazy_listener_invoke_doc" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:${local.aws_region}:${local.account_id}:function:slack-bolt-app"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "allow_lazy_listener_invoke" {
  name        = "allow-lazy-listener-invoke-policy"
  description = "Allows Lazy Listener Invoke"
  policy      = data.aws_iam_policy_document.allow_lazy_listener_invoke_doc.json
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.0.0"

  function_name                           = "slack-bolt-app"
  description                             = "Slack bolt lambda function"
  handler                                 = "handler.handler"
  runtime                                 = "python3.10"
  create_package                          = false
  local_existing_package                  = "build/lambda.zip"
  tracing_mode                            = "Active"
  create_current_version_allowed_triggers = false
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
  environment_variables = {
    SLACK_BOT_TOKEN      = var.slack_bot_token
    SLACK_SIGNING_SECRET = var.slack_signing_secret
  }
  attach_policy = true
  policy        = aws_iam_policy.allow_lazy_listener_invoke.arn
}



#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name = "slack-bolt-app-apigateway-logs"
}

module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.2.2"

  name          = "slack-bolt-app-api-gateway"
  description   = "API Gateway for slack bolt app"
  protocol_type = "HTTP"

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.api_gateway_log_group.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  create_api_domain_name = false

  # Routes and integrations
  integrations = {
    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
  }

  tags = {
    Name = "http-apigateway"
  }
}