# Allows SSH 22 access from the jumphost and Mongodb 27017 from the application server.
resource "aws_security_group" "database_access" {
  name        = "access-to-${var.stage}-${var.env_name}-db"
  description = "Allow internal 22,27017 traffic to Database server."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.application_access.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jumphost_access.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creates a static elastic ip reserved for the database server.
resource "aws_eip" "database" {
  depends_on = [aws_instance.database]
  instance   = aws_instance.database.id
  domain     = "vpc"
  tags = {
    "Name" : "${var.stage}-${var.env_name}-db-eip"
  }
}

# Create the ec2 instance (server) to deploy the database on (not publicly accessible).
resource "aws_instance" "database" {
  depends_on             = [aws_key_pair.deployer]
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.db_instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = random_shuffle.random_public_subnet.result[0]
  vpc_security_group_ids = [aws_security_group.database_access.id]

  root_block_device {
    volume_size = 20 # 20GB EBS storage
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.stage}-${var.env_name}-db"
  }
}