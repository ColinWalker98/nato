output "private_app_ip" {
  value = aws_instance.application.private_ip
}

output "private_db_ip" {
  value = aws_instance.database.private_ip
}

output "public_jumphost_ip" {
  value = aws_eip.jumphost
}

output "loadbalancer_dns" {
  value = aws_lb.loadbalancer.dns_name
}