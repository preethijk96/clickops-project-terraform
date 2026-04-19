resource "aws_security_group" "sg" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data.aws_secretsmanager_secret_version.mongo.secret_string

locals {
  mongo_creds = jsondecode(data.aws_secretsmanager_secret_version.mongo.secret_string)
}

resource "aws_key_pair" "deployer" {
  key_name   = "clickops-key"
  public_key = file("/root/.ssh/id_rsa.pub")
}


resource "aws_instance" "ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile   = var.instance_profile

  tags = {
    Name = var.ec2_name
  }

  user_data = <<-EOF
  #!/bin/bash

  apt update -y
  apt install -y docker.io curl unzip

  systemctl start docker
  systemctl enable docker

  # AWS CLI
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install

  aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.frontend_image}

  docker pull ${var.frontend_image}:fe-v1
  docker pull ${var.backend_image}:be-v1

  docker network create app-net || true

  docker run -d --name mongodb --network app-net mongo

  docker run -d --name backend --network app-net -p 3000:3000 \
    -e MONGO_USERNAME=${local.mongo_creds.username} \
    -e MONGO_PASSWORD=${local.mongo_creds.password} \
    ${var.backend_image}:be-v1

  docker run -d --name frontend -p 80:80 \
    ${var.frontend_image}:fe-v1
  EOF
}