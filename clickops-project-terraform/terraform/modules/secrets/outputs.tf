output "secret_name" {
  value = aws_secretsmanager_secret.secret.name
}

output "secret_arn" {
  value = aws_secretsmanager_secret.secret.arn
}
output "secret_string" {
  value     = aws_secretsmanager_secret_version.value.secret_string
  sensitive = true
}