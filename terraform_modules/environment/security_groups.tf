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

# Allows HTTP 80 access from the provided IP range to the load balancer.
resource "aws_security_group" "loadbalancer_access" {
  name        = "access-to-${var.stage}-${var.env_name}-loadbalancer"
  description = "Allow external 80 traffic to the loadbalancer."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allows SSH 22 access from the jumphost and HTTP 80 from the load balancer.
resource "aws_security_group" "application_access" {
  name        = "access-to-${var.stage}-${var.env_name}-app"
  description = "Allow internal 22,80 traffic to Application server."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.loadbalancer_access.id]
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

