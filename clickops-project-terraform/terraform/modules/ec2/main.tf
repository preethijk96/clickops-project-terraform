########################################
# VARIABLES
########################################

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "environment" {
  type = string
}

########################################
# SECURITY GROUP
########################################

resource "aws_security_group" "app_sg" {
  name        = "clickops-${var.environment}-sg"
  description = "Allow SSH + App Traffic"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend APIs
  ingress {
    from_port   = 5001
    to_port     = 5003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend apps
  ingress {
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "clickops-${var.environment}-sg"
    Environment = var.environment
  }
}

########################################
# EC2 INSTANCE
########################################

resource "aws_instance" "app" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name

  # critical for SSH access
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  ####################################
  # Auto configure SSH on launch
  ####################################
  user_data = <<-EOF
#!/bin/bash
apt-get update -y

apt-get install -y openssh-server docker.io docker-compose

systemctl enable ssh
systemctl restart ssh

mkdir -p /home/ubuntu/.ssh
chown ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

echo "SSH enabled successfully" > /home/ubuntu/setup.log
EOF

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name        = "clickops-ec2-${var.environment}"
    Environment = var.environment
  }
}

########################################
# OUTPUTS
########################################

output "instance_id" {
  value = aws_instance.app.id
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "security_group_id" {
  value = aws_security_group.app_sg.id
}