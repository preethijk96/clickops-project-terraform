resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "policy" {
  name = "${var.role_name}-policy"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:*",
        "s3:*",
        "secretsmanager:*",
        "logs:*"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.role.name
}