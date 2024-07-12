output "public-app-ip" {
  value = aws_eip.application
}
output "private-app-ip" {
  value = aws_instance.application.private_ip
}
output "public-db-ip" {
  value = aws_eip.database
}
output "private-db-ip" {
  value = aws_instance.database.private_ip
}
