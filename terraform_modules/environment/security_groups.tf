# Allows SSH 22 access from the provided IP range to the jumphost.
resource "aws_security_group" "jumphost_access" {
  name        = "access-to-${var.stage}-jumphost"
  description = "Allow external traffic to the jumphost."
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
  name        = "access-to-${var.stage}-loadbalancer"
  description = "Allow external traffic to the loadbalancer."
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
  name        = "access-to-${var.stage}-app"
  description = "Allow traffic from Loadbalancer to Application server."
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

# Allows SSH 22 access from the jumphost and MYSQL 3306 from the application server.
resource "aws_security_group" "database_access" {
  name        = "access-to-${var.stage}-db"
  description = "Allow traffic from Application server to Database server."
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
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

