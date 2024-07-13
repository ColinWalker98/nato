resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_shuffle" "random_public_subnet" {
  input        = aws_subnet.default_public[*].id
  result_count = 1
}

resource "random_shuffle" "random_private_subnet" {
  input        = aws_subnet.default_private[*].id
  result_count = 1
}