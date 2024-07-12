provider "aws" {
  region = "eu-central-1"
  assume_role {
    role_arn     = "arn:aws:iam::743558884073:role/terraform-operator"
  }
}