module "acc_app" {
  source        = "../../terraform_modules/environment"
  aws_region    = "eu-west-1"
  instance_type = "t2.micro"
  stage         = "acc"
  env_name      = "web"
  accountid     = "743558884073"
}


