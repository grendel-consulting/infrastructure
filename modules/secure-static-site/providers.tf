terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.4.0"
    }
  }
}

provider "aws" { alias = "resources" }
provider "aws" { alias = "cloudfront" }