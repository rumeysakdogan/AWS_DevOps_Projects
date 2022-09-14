terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.28.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

provider "github" {
  # Configuration options
  token = "XXXXXXXXXXXXXXXXXXXXX"
}