locals {
  app_instance_type = var.app_instance_type != "" ? var.app_instance_type : var.instance_type
  db_instance_type  = var.db_instance_type != "" ? var.db_instance_type : var.instance_type
  cidr_block        = var.custom_cidr == "" ? var.cidr_blocks[var.stage] : var.custom_cidr
  subnet_pub_cidrs  = length(var.custom_subnet_pub_cidrs) == 0 ? var.subnet_pub_cidrs[var.stage] : var.custom_subnet_pub_cidrs
  subnet_priv_cidrs = length(var.custom_subnet_priv_cidrs) == 0 ? var.subnet_priv_cidrs[var.stage] : var.custom_subnet_priv_cidrs
}

variable "aws_region" {
  description = "Defines the region where to deploy the resources."
  type        = string
  default     = "eu-central-1"
}

variable "accountid" {
  description = "Defines the aws account in which to deploy the resources."
  type        = string
  required    = yes
}

variable "instance_type" {
  description = "Instance type for both app and db servers, by default free tier."
  type        = string
  default     = "t2.micro"
}

variable "public_key_path" {
  description = "Path to the public key, update this path if your key is located elsewhere."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "app_instance_type" {
  description = "Instance type override for app instance. If not set, reverts to var.instance_type."
  type        = string
  default     = ""
}
variable "db_instance_type" {
  description = "Instance type override for db instance. If not set, reverts to var.instance_type."
  type        = string
  default     = ""
}

variable "allowed_ssh_access" {
  description = "IP to allow access over ssh. Defaults to quad zero."
  type        = list(string)
  default     = ["45.80.136.238/32"]
}

variable "stage" {
  description = "Stage of the environments (dev / acceptance / production)."
  type        = string
  default     = "dev"
  required    = yes
}

variable "vpc_name" {
  description = "Name of the vpc."
  type        = string
  default     = "vpc"
}

variable "sub_count" {
  description = "Amount of subnets (Subnet group per availability zone that is used)."
  type        = string
  default     = "2"
}

variable "cidr_blocks" {
  description = "Main CIDR Blocks for vpc based on stage of the environment."
  type        = object({ dev : string, acc : string, prod : string })
  default = {
    "prod" = "10.0.0.0/16", #- with subnets [10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24, 10.0.4.0/24 10.0.5.0/24, 10.0.5.0/24, ....]
    "acc"  = "10.1.0.0/16", #- with subnets [10.1.1.0/24, 10.1.2.0/24, 10.1.3.0/24, 10.1.4.0/24 10.1.5.0/24, 10.1.5.0/24, ....]
    "dev"  = "10.2.0.0/16", #- with subnets [10.2.1.0/24, 10.2.2.0/24, 10.2.3.0/24, 10.2.4.0/24 10.2.5.0/24, 10.2.5.0/24, ....]
  }
}

variable "subnet_pub_cidrs" {
  description = "Public subnet ranges (requires 3 entries)."
  type        = object({ dev : list(string), acc : list(string), prod : list(string) })
  default = {
    "prod" = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
    "acc"  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
    "dev"  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24", "10.2.7.0/24", "10.2.8.0/24", "10.2.9.0/24"]
  }
}

variable "subnet_priv_cidrs" {
  description = "Private subnet ranges (requires 3 entries)."
  type        = object({ dev : list(string), acc : list(string), prod : list(string) })
  default = {
    prod = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
    acc  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24", "10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]
    dev  = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24", "10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"]
  }
}

variable "custom_cidr" {
  description = "Option to provide custom CIDR range if desired, this overrides the default provided lists based on the environment stage."
  type        = string
  default     = ""
}

variable "custom_subnet_pub_cidrs" {
  description = "Option to override with custom public subnet CIDR."
  type        = list(string)
  default     = []
}

variable "custom_subnet_priv_cidrs" {
  description = "Option to override with custom private subnet CIDR."
  type        = list(string)
  default     = []
}