terraform {
  backend "s3" {
    key            = "dev/web/terraform.tfstate"
    bucket         = "terraform-remote-state-nato"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-remote-state-lock-nato"
  }
}

module "dev_web_env" {
  source                     = "../../terraform_modules/environment"
  aws_region                 = "eu-central-1"
  instance_type              = "t2.micro"
  stage                      = "dev"
  env_name                   = "web"
  accountid                  = "743558884073"
  fully_automated_deployment = true
}


