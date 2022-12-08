terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.45.0"
    }
     github = {
      source = "integrations/github"
      version = "5.11.0"
    }
  }
}

provider "github" {
  token = var.token
}

provider "aws" {
  region = var.region
}