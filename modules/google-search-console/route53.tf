# Presume this exists?
data "aws_route53_zone" "existing" {
  name         = var.domain
  private_zone = false
}

locals {
  ttl = 60
}

resource "aws_route53_record" "domain_verification" {
  provider = aws.resources

  name    = var.domain
  records = [ var.verification_token ]
  type    = "TXT"
  ttl     = local.ttl

  zone_id         = data.aws_route53_zone.existing.zone_id
}