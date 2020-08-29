resource "aws_acm_certificate" "https_cert" {
  provider = aws.cloudfront

  domain_name       = "${var.subdomain}.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "https_cert" {
  provider = aws.cloudfront

  certificate_arn         = aws_acm_certificate.https_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.https_validation : record.fqdn]

  # Required since create_before_destroy is set to true in the ACM certificate;
  # otherwise you'll see cyclic dependency errors when attempting destroy
  lifecycle {
    create_before_destroy = true
  }
}