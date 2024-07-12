variable "aws_region" {
  default = "eu-central-1"
  description = "Defines the region where to deploy the resources."
}

variable "accountid" {
  default = "743558884073"
  description = "Defines the aws account in which to deploy the resources."
}

variable "instance_type" {
  description = "Instance type for both servers, by default free tier."
  default = "t2.micro"
}

variable "public_key_path" {
  description = "Path to the public key, update this path if your key is located elsewhere"
  default     = "~/.ssh/id_rsa.pub"
}

variable "app_instance_type" {
  description = "Instance type for both app instance, by default free tier."
  default = ""
}
variable "db_instance_type" {
  description = "Instance type for both db instance, by default free tier."
  default = ""
}

variable "allowed_ssh_access" {
  description = "IP to allow access over ssh. Defaults to quad zero."
  default = ["45.80.136.238/32"]
}

variable "stage" {
  description = "Stage of the environments (dev / acceptance / production)"
  default = "dev"
}

locals {
  app_instance_type = var.app_instance_type != "" ? var.app_instance_type : var.instance_type
  db_instance_type = var.db_instance_type != "" ? var.db_instance_type : var.instance_type
}