locals {
  fn = "secure-headers"
}

data "archive_file" "secure_headers_source" {
  type        = "zip"
  source_dir  = "${path.module}/${local.fn}"
  output_path = "${path.module}/${local.fn}.zip"
}

# Based on https://aws.amazon.com/blogs/networking-and-content-delivery/adding-http-security-headers-using-lambdaedge-and-amazon-cloudfront/
resource "aws_lambda_function" "secure_headers" {
  function_name = local.fn
  description   = "Enrich origin-response with well-known security headers"

  provider = aws.cloudfront

  runtime = "nodejs10.x"
  role    = aws_iam_role.secure_headers.arn

  filename         = data.archive_file.secure_headers_source.output_path
  source_code_hash = data.archive_file.secure_headers_source.output_base64sha256
  handler          = "lambda.handler"
  publish          = true

  tracing_config {
    mode = "Active"
  }

  reserved_concurrent_executions = 0

  # lifecycle {
  #   ignore_changes = [source_code_hash]
  # }
}