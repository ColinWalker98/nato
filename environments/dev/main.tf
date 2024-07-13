module "dev_app" {
  source                     = "../../terraform_modules/environment"
  aws_region                 = "eu-central-1"
  instance_type              = "t2.micro"
  stage                      = "dev"
  env_name                   = "web"
  accountid                  = "743558884073"
  fully_automated_deployment = true
}


