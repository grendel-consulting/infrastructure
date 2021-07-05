variable "header_key" {
  description = "Custom HTTP header passed from CloudFront to S3 to prevent bypass"
  sensitive   = true
  type        = string
}

variable "header_secret" {
  description = "Custom HTTP secret passed from CloudFront to S3 to prevent bypass"
  sensitive   = true
  type        = string
}

