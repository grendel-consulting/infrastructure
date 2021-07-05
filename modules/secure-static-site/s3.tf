locals {
  content_type_regex = "\\.(?P<extension>[A-Za-z0-9]+)$"
  content_type_map = {
    html = "text/html",
    txt  = "text/plain"
  }
  content_type_default = "application.octet-stream"

  placeholder_index_page = "default_pages/index.html"
  placeholder_error_page = "default_pages/error.html"
}

resource "aws_s3_bucket" "web_container" {
  provider = aws.resources

  bucket = "${var.subdomain}.${var.domain}"
  acl    = "private"
  policy = data.aws_iam_policy_document.web_container_policy.json

  logging {
     target_bucket = aws_s3_bucket.log_container.id
     target_prefix = "log/${var.subdomain}.${var.domain}"
  }

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }

  versioning {
    enabled    = true
  }

  website {
    index_document = var.index_page
    error_document = var.error_page
  }

  force_destroy = var.force_destroy
}

# Pattern based on https://chrisdecairos.ca/s3-objects-terraform/
resource "aws_s3_bucket_object" "web_content" {
  for_each = fileset(var.contents, "**")

  provider = aws.resources

  bucket       = aws_s3_bucket.web_container.id
  key          = each.value
  source       = "${var.contents}/${each.value}"
  content_type = lookup(local.content_type_map, regex(local.content_type_regex, each.value).extension, local.content_type_default)
}

resource "aws_s3_bucket_object" "default_index" {
  count = fileexists("${var.contents}/${var.index_page}") ? 0 : 1

  provider = aws.resources

  bucket       = aws_s3_bucket.web_container.id
  key          = var.index_page
  source       = "${path.module}/${local.placeholder_index_page}"
  content_type = lookup(local.content_type_map, regex(local.content_type_regex, local.placeholder_index_page).extension, local.content_type_default)
}

resource "aws_s3_bucket_object" "default_error" {
  count = fileexists("${var.contents}/${var.error_page}") ? 0 : 1

  provider = aws.resources

  bucket       = aws_s3_bucket.web_container.id
  key          = var.error_page
  source       = "${path.module}/${local.placeholder_error_page}"
  content_type = lookup(local.content_type_map, regex(local.content_type_regex, local.placeholder_error_page).extension, local.content_type_default)
}

resource "aws_s3_bucket" "log_container" {
  provider = aws.resources

  bucket = "${var.subdomain}.${var.domain}-logs"
  acl    = "log-delivery-write"

  logging {
     target_bucket = "${var.subdomain}.${var.domain}-logs"
     target_prefix = "log/${var.subdomain}.${var.domain}-logs"
  }

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }

  versioning {
    enabled    = true
  }
}