resource "aws_instance" "ec2" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t3.micro"

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile   = var.iam_profile
  key_name               = var.key_name

  user_data = <<-EOF
  #!/bin/bash
  apt update -y

  # Install Docker
  apt install -y docker.io docker-compose
  systemctl start docker
  usermod -aG docker ubuntu

  # Install AWS CLI
  apt install -y unzip curl
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install

  # Login to ECR
  aws ecr get-login-password --region ap-south-1 | \
  docker login --username AWS --password-stdin ${var.ecr_url}

  # Pull images
  docker pull ${var.ecr_url}:fe-v1
  docker pull ${var.ecr_url}:be-v1

  # Run containers
  docker network create app-net

  docker run -d --name mongodb --network app-net mongo

  docker run -d --name backend --network app-net -p 3000:3000 \
    -e BUCKET_NAME=${var.bucket_name} \
    -e SECRET_NAME=${var.secret_name} \
    -e MONGO_HOST=mongodb \
    -e MONGO_PORT=27017 \
    ${var.ecr_url}:be-v1

  docker run -d --name frontend -p 80:80 \
    ${var.ecr_url}:fe-v1

  EOF

  tags = {
    Name = var.instance_name
  }
}