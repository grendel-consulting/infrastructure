module "google_search_console" {
  source = "../google-search-console"

  providers = {
    aws.resources = aws.resources
  }

  domain    = var.domain
  subdomain = var.subdomain
  token     = var.token
}
