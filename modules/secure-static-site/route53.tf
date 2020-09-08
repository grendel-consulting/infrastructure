# Presume this exists?
data "aws_route53_zone" "existing" {
  name         = var.domain
  private_zone = false
}

locals {
  ttl = 60
}

resource "aws_route53_record" "web_redirect" {
  provider = aws.resources

  name    = "${var.subdomain}.${var.domain}"
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.cdn.domain_name
    evaluate_target_health = false
    zone_id = aws_cloudfront_distribution.cdn.hosted_zone_id
  }

  zone_id         = data.aws_route53_zone.existing.zone_id
}

resource "aws_route53_record" "https_validation" {
  for_each = {
    for vo in aws_acm_certificate.https_cert.domain_validation_options : vo.domain_name => {
      name   = vo.resource_record_name
      type   = vo.resource_record_type
      record = vo.resource_record_value
    }
  }

  provider = aws.resources

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  ttl     = local.ttl

  zone_id         = data.aws_route53_zone.existing.zone_id
  allow_overwrite = true

  # Required since create_before_destroy is set to true in the ACM certificate;
  # otherwise you'll see cyclic dependency errors when attempting destroy
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "caa" {
  provider = aws.resources

  name    = "${var.subdomain}.${var.domain}"
  records = [ "0 issue \"amazon.com\"" ]
  type    = "CAA"
  ttl     = local.ttl

  zone_id         = data.aws_route53_zone.existing.zone_id
}