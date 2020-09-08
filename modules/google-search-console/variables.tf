variable "domain" {
  description = "Root domain name for verification"
  type        = string
}

variable "subdomain" {
  description = "Subdomain prefix for verification"
  type        = string
}

variable "token" {
  description = "Token from Google Search Console"
  type        = string
}
