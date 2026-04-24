resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-clickops-sg"
  description = "Security group for ${var.environment}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.backend_port
    to_port   = var.backend_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.frontend_port
    to_port   = var.frontend_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y openssh-server docker.io docker-compose

systemctl enable ssh
systemctl restart ssh

usermod -s /bin/bash ubuntu
cp /etc/skel/.bashrc /home/ubuntu/.bashrc
cp /etc/skel/.profile /home/ubuntu/.profile
chown ubuntu:ubuntu /home/ubuntu/.bashrc /home/ubuntu/.profile

echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config

systemctl restart ssh
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu
EOF

  tags = {
    Name = "clickops-ec2-${var.environment}"
    Environment = var.environment
  }
}

output "public_ip" {
  value = aws_instance.app.public_ip
}