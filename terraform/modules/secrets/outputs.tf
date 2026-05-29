output "secret_name" {
  value = aws_secretsmanager_secret.mongo.name
}

output "secret_arn" {
  value = aws_secretsmanager_secret.mongo.arn
}

output "secret_string" {
  value     = aws_secretsmanager_secret_version.mongo_secret_value.secret_string
  sensitive = true
}