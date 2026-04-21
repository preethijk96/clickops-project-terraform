resource "aws_secretsmanager_secret" "secret" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "value" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({
    username = var.username
    password = var.password
    host     = var.host
    port     = var.port
  })
}
resource "aws_secretsmanager_secret" "mongo" {
  name = "clickops-sm-dev"
}

resource "aws_secretsmanager_secret_version" "mongo" {
  secret_id     = aws_secretsmanager_secret.mongo.id
  secret_string = jsonencode({
    host = "mongo"
    port = 27017
  })
}
resource "aws_secretsmanager_secret" "clickops" {
  name = "clickops-secret"
}

resource "aws_secretsmanager_secret_version" "clickops_value" {
  secret_id = aws_secretsmanager_secret.clickops.id

  secret_string = jsonencode({
    bucket = var.bucket_name
  })
}