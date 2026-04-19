output "public_ip" {
  value = aws_instance.ec2.public_ip
}
output "secret_string" {
  value     = aws_secretsmanager_secret_version.value.secret_string
  sensitive = true
}