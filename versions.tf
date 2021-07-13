terraform {
  required_version = "~> 1.0"

  backend "remote" {
    organization = "grendel-consulting"

    workspaces {
      name = "infrastructure"
    }
  }

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.2.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.4.0"
    }
  }
}