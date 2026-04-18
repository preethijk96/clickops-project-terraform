resource "aws_iam_role" "ec2_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach multiple policies
resource "aws_iam_role_policy_attachment" "attach" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.ec2_role.name
  policy_arn = each.value
}

# Instance profile
resource "aws_iam_instance_profile" "profile" {
  name = var.role_name
  role = aws_iam_role.ec2_role.name
}