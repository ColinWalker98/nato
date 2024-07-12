#--------------------------------------------------------------
# This module creates all resources necessary for a vpc
#--------------------------------------------------------------
locals {
  cidr_block = var.custom_cidr == "" ? var.cidr_blocks[var.stage] : var.custom_cidr
  subnet_pub_cidrs = length(var.custom_subnet_pub_cidrs) == 0 ? var.subnet_pub_cidrs[var.stage] : var.custom_subnet_pub_cidrs
  subnet_priv_cidrs = length(var.custom_subnet_priv_cidrs) == 0 ? var.subnet_priv_cidrs[var.stage] : var.custom_subnet_priv_cidrs
}

variable "vpc_name" {
  description = "Name of the vpc."
  default = "vpc"
}

variable "sub_count" {
  description = "Amount of subnets (Subnet group per availability zone that is used)."
  default     = "1"
}

variable "cidr_blocks" {
  description="Main CIDR Blocks for vpc."
  type    = object({dev: string, acc: string, prod: string})
  default = {
    "prod"   = "10.0.0.0/16", #- with subnets [10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24, 10.0.4.0/24 10.0.5.0/24, 10.0.5.0/24, ....]
    "acc"    = "10.1.0.0/16", #- with subnets [10.1.1.0/24, 10.1.2.0/24, 10.1.3.0/24, 10.1.4.0/24 10.1.5.0/24, 10.1.5.0/24, ....]
    "dev"    = "10.2.0.0/16", #- with subnets [10.2.1.0/24, 10.2.2.0/24, 10.2.3.0/24, 10.2.4.0/24 10.2.5.0/24, 10.2.5.0/24, ....]
  }
}

variable "subnet_pub_cidrs" {
  description = "Public subnet ranges (requires 3 entries)."
  type    = object({dev: list(string), acc: list(string), prod: list(string)})
  default = {
    "prod"   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24","10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
    "acc"    = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24","10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
    "dev"    = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24","10.2.7.0/24", "10.2.8.0/24", "10.2.9.0/24"]
  }
}

variable "subnet_priv_cidrs" {
  description = "Private subnet ranges (requires 3 entries)."
  type    = object({dev: list(string), acc: list(string), prod: list(string)})
  default = {
    prod   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24","10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
    acc    = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24","10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]
    dev    = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24","10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"]
  }
}

variable "custom_cidr" {
  description = "Option to provide custom CIDR range if desired, this overrides the default provided lists based on the environment stage."
  type = string
  default = ""
}

variable "custom_subnet_pub_cidrs" {
  description = "Option to override with custom public subnet CIDR."
  type = list(string)
  default = []
}

variable "custom_subnet_priv_cidrs" {
  description = "Option to override with custom private subnet CIDR."
  type = list(string)
  default = []
}

data "aws_availability_zones" "available" {}

#--------------------------------------------------------------
# Setup
#--------------------------------------------------------------

# Create a VPC
resource "aws_vpc" "default" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.stage}-${var.vpc_name}"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.stage}-ig"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create public subnets
resource "aws_subnet" "default_public" {
  count                   = var.sub_count
  vpc_id                  = aws_vpc.default.id
  cidr_block              = element(local.subnet_pub_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.stage}-pub_subnet-${count.index}"
  }
}

# Create private subnet
resource "aws_subnet" "default_private" {
  count             = var.sub_count
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(local.subnet_priv_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.stage}-priv_subnet-${count.index}"
  }
}



