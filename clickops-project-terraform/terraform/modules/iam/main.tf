resource "aws_iam_role" "ec2_role" {

  name = "clickops-ec2-role"

  assume_role_policy = jsonencode({
    Version="2012-10-17"
    Statement=[
      {
        Effect="Allow"
        Principal={
          Service="ec2.amazonaws.com"
        }
        Action="sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn ="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn ="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {

 name = "clickops-instance-profile"
 role = aws_iam_role.ec2_role.name

}
