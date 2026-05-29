resource "aws_ecr_repository" "frontend" {
 name = "${var.repo_name}-frontend"
}

resource "aws_ecr_repository" "backend" {
 name = "${var.repo_name}-backend"
}
