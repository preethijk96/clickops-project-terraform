resource "aws_secretsmanager_secret" "mongo" {

  name = var.secret_name

  description = "Mongo credentials for ${var.environment}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.secret_name
    Environment = var.environment
  }
}


resource "aws_secretsmanager_secret_version" "mongo_secret_value" {

  secret_id = aws_secretsmanager_secret.mongo.id

  secret_string = jsonencode({
    username = var.username
    password = var.password
    host     = var.host
    port     = var.port
  })

}


output "secret_arn" {
 value = aws_secretsmanager_secret.mongo.arn
}

output "secret_name" {
 value = aws_secretsmanager_secret.mongo.name
}

output "secret_string" {
 value = aws_secretsmanager_secret_version.mongo_secret_value.secret_string
 sensitive = true
}
