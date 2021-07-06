resource "aws_iam_role" "secure_headers" {
  provider = aws.resources

  assume_role_policy = data.aws_iam_policy_document.assumption_policy.json
}

resource "aws_iam_role_policy" "secure_headers_policy" {
  provider = aws.resources

  role = aws_iam_role.secure_headers.id
  policy = data.aws_iam_policy_document.logging_policy.json
}

resource "aws_iam_role_policy_attachment" "tracing_policy" {
  provider = aws.resources

  role = aws_iam_role.secure_headers.id
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}