resource "aws_iam_role" "secure_headers" {
  provider = aws.resources

  assume_role_policy = data.aws_iam_policy_document.assumption_policy.json
}