variable "domain" {
  description = "Root domain name for the secure static site"
  type        = string
}

variable "subdomain" {
  description = "Subdomain prefix for the secure static site"
  type        = string
}

variable "header" {
  description = "Custom HTTP header passed from CloudFront to S3 to prevent bypass"
  type        = string
}

variable "secret" {
  description = "Custom HTTP secret passed from CloudFront to S3 to prevent bypass"
  type        = string
}

variable "contents" {
  description = "Filepath where static content resides"
  type        = string
}

variable "index_page" {
  description = "Filename that serves as the index page"
  type        = string
  default     = "index.html"
}

variable "error_page" {
  description = "Filename that serves as the error page"
  type        = string
  default     = "error.html"
}

variable "force_destroy" {
  description = "Destroy the underlying S3 bucket and contents"
  type        = string
  default     = "false"
}

variable "token" {
  description = "Token from Google Search Console"
  type        = string
}

variable "tags" {
  description = "List of extra tag blocks to be used"
  type        = list(object({ key : string, value : string }))
}