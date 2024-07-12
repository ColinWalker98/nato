module "dev_app" {
  source = "../../terraform_modules/environment"
  aws_region = "eu-central-1"
  instance_type = "t2.micro"
  stage = "dev"
  public_key_path = "~/.ssh/id_ecdsa.pub"
}


