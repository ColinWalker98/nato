terraform {
  backend "s3" {
    key            = "acc/terraform.tfstate"
    bucket         = "terraform-remote-state-nato"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-remote-state-lock-nato"
  }
}