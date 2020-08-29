terraform {
  required_version = "~> 0.13"

  backend "remote" {
    organization = "grendel-consulting"

    workspaces {
      name = "infrastructure"
    }
  }
}

module "secure_static_site" {
  source = "./modules/secure-static-site"
  providers = {
    aws.resources  = aws
    aws.cloudfront = aws.cloudfront
  }

  domain    = "grendel-consulting.com"
  subdomain = "mta-sts"
  header    = var.header_key
  secret    = var.header_secret
  contents  = "./data/mta-sts"

  tags = [
    {
      key   = "Environment"
      value = "production"
    }
  ]
}