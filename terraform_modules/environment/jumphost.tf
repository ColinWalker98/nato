# Allows SSH 22 access from the provided IP range to the jumphost.
resource "aws_security_group" "jumphost_access" {
  name        = "access-to-${var.stage}-${var.env_name}-jumphost"
  description = "Allow external 22 traffic to the jumphost."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creates a static elastic ip reserved for the jumphost server.
resource "aws_eip" "jumphost" {
  depends_on = [aws_instance.jumphost]
  instance   = aws_instance.jumphost.id
  domain     = "vpc"
  tags = {
    "Name" : "${var.stage}-${var.env_name}-jumphost-eip"
  }
}

# Create the ec2 instance (server) that will act as jumphost (publicly accessible).
resource "aws_instance" "jumphost" {
  depends_on             = [aws_key_pair.deployer]
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = random_shuffle.random_public_subnet.result[0]
  vpc_security_group_ids = [aws_security_group.jumphost_access.id]

  tags = {
    Name = "${var.stage}-${var.env_name}-jumphost"
  }
}