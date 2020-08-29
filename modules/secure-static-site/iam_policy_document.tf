data "aws_iam_policy_document" "web_container_policy" {
  statement {
    sid = "CloudFrontReadable"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:${var.header}"
      values   = ["${var.secret}"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.subdomain}.${var.domain}/*"
    ]
  }
}

data "aws_iam_policy_document" "assumption_policy" {
  statement {
    sid = "CloudFrontAssumption"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}