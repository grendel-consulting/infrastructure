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
  token     = "google-site-verification=EAGZ-800Vy8480lV6oYu3Plvg_FTSw2qnCRMCioK_yk"
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

