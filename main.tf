data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "main" {
  filename         = data.archive_file.package.output_path
  function_name    = "${var.nameprefix}-function"
  role             = aws_iam_role.lambda.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.package.output_base64sha256
  runtime          = "python3.9"

  publish = true

  memory_size = 150
  timeout     = 30

  environment {
    variables = {
      TAG_KEYS   = join(" ", keys(var.tags))
      TAG_VALUES = join(" ", values(var.tags))
    }
  }
}

data "archive_file" "package" {
  type        = "zip"
  output_path = "${path.module}/lambda/dst/package.zip"
  source {
    content  = file("${path.module}/lambda/src/main.py")
    filename = "main.py"
  }
}

data "aws_s3_bucket" "target" {
  bucket = var.s3_bucket_name
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id_prefix = "AllowExecutionFromS3Bucket"
  action              = "lambda:InvokeFunction"
  function_name       = aws_lambda_function.main.arn
  principal           = "s3.amazonaws.com"
  source_arn          = data.aws_s3_bucket.target.arn
  source_account      = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket_notification" "notification" {
  bucket = data.aws_s3_bucket.target.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.main.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.prefix
    filter_suffix       = var.suffix
  }
  depends_on = [
    aws_lambda_permission.allow_bucket
  ]
}
