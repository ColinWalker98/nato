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

# Creates a listener, the load balancer will then actively listen on this port / protocol.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

# Creates a target group, which is used to forward traffic to the targets when received on the load balancer.
resource "aws_lb_target_group" "http" {
  name     = "application-server-tg-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
}

# Register the application instance as a target.
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.application.id
  port             = 80
}

output "loadbalancer_public_dns" {
  value = aws_lb.loadbalancer.dns_name
}

# Creates the load balancer itself and assigns a subnet and security group (firewall).
resource "aws_lb" "loadbalancer" {
  name               = "${var.stage}-${var.env_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer_access.id]
  subnets            = aws_subnet.default_public[*].id

  tags = {
    Name = "${var.stage}-${var.env_name}-lb"
  }
}
