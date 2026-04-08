resource "aws_secretsmanager_secret" "secret" {
  name = "${var.secret_name}-${var.environment}"
}

resource "aws_secretsmanager_secret_version" "value" {
  secret_id = aws_secretsmanager_secret.secret.id

  secret_string = jsonencode({
    username = var.username
    password = var.password
    host     = var.host
    port     = var.port
  })
}