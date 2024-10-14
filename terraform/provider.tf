provider "aws" {
  region = "us-east-2"
}

terraform {
  cloud {
    organization = "north-demo"

    workspaces {
      name = "missouri"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
}
