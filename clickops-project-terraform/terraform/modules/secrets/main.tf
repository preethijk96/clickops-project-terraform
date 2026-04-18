resource "aws_secretsmanager_secret" "secret" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "value" {
  secret_id = aws_secretsmanager_secret.secret.id

  secret_string = jsonencode({
    username = "admin"
    password = "password123"
  })
}