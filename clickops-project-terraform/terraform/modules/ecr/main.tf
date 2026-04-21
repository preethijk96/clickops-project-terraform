resource "aws_ecr_repository" "frontend" {
  name = "${var.ecr_name}-${var.environment}-frontend"
}

resource "aws_ecr_repository" "backend" {
  name = "${var.ecr_name}-${var.environment}-backend"
}
resource "aws_ecr_repository" "repo" {
  name = var.ecr_name
}