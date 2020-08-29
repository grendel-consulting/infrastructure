locals {
  s3_origin_id = "origin-${aws_s3_bucket.web_container.id}"
}

resource "aws_cloudfront_distribution" "cdn" {
  provider = aws.cloudfront

  origin {
    origin_id   = local.s3_origin_id
    domain_name = aws_s3_bucket.web_container.website_endpoint

    custom_origin_config {
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      https_port             = "443"
      http_port              = "80"
    }

    custom_header {
      name  = var.header
      value = var.secret
    }
  }

  aliases = [ "${var.subdomain}.${var.domain}" ]

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = aws_lambda_function.secure_headers.qualified_arn
    }

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.https_cert.certificate_arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }

  enabled = true

  # Required since create_before_destroy is set to true in the ACM certificate;
  # otherwise you'll see cyclic dependency errors when attempting destroy
  lifecycle {
    create_before_destroy = true
  }
}