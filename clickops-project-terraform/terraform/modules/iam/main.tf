resource "aws_iam_role" "ec2_role" {
  name = "clickops-iam-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version="2012-10-17"
    Statement=[{
      Effect="Allow"
      Principal={
        Service="ec2.amazonaws.com"
      }
      Action="sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "terraform_policy" {
  name = "terraform-policy-${var.environment}"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version="2012-10-17"
    Statement=[
      {
        Effect="Allow"
        Action="*"
        Resource="*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "profile" {
  name = "clickops-role-${var.environment}"
  role = aws_iam_role.ec2_role.name
}