data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}-${var.lambda_code_bucket_name}"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_code_bucket.id
  key    = "lambda.zip"
  source = "build/lambda.zip"
}
