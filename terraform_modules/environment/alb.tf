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
