provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.accountid}:role/terraform-operator"
  }
}

terraform {
  required_version = "1.9.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.58.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }
}