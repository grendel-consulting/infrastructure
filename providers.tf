provider "aws" {
  version = "~> 3.4"
  region  = "eu-west-1"
}

provider "aws" {
  version = "~> 3.4"
  region  = "us-east-1"
  alias   = "cloudfront"
}

provider "archive" {}