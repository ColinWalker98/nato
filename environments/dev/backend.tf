terraform {
  backend "s3" {
    key            = "dev/terraform.tfstate"
    bucket         = "terraform-remote-state-nato"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-remote-state-lock-nato"
  }
}

provider "aws" {
  region = "eu-central-1"
  assume_role {
    role_arn     = "arn:aws:iam::743558884073:role/terraform-operator"
  }
}