# Fetch available subnets in the provided region.
data "aws_availability_zones" "available" {}

# Create a VPC.
resource "aws_vpc" "default" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.stage}-${var.env_name}-${var.vpc_name}"
  }
}

# Create an internet gateway to give our subnet access to the outside world.
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.stage}-${var.env_name}-ig"
  }
}

# Grant the VPC internet access on its main route table.
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create public subnets.
resource "aws_subnet" "default_public" {
  count                   = var.sub_count
  vpc_id                  = aws_vpc.default.id
  cidr_block              = element(local.subnet_pub_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.stage}-${var.env_name}-pub_subnet-${count.index}"
  }
}

# Create 'private' subnet.
resource "aws_subnet" "default_private" {
  count             = var.sub_count
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(local.subnet_priv_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.stage}-${var.env_name}-priv_subnet-${count.index}"
  }
}



