resource "aws_security_group" "app_sg" {
  name        = "clickops-sg-qa"
  description = "Allow SSH and app ports"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5002
    to_port     = 5002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
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

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  user_data = <<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y openssh-server docker.io docker-compose

systemctl enable ssh
systemctl restart ssh

# force ubuntu user shell
usermod -s /bin/bash ubuntu

# repair ubuntu shell files
cp /etc/skel/.bashrc /home/ubuntu/.bashrc
cp /etc/skel/.profile /home/ubuntu/.profile
chown ubuntu:ubuntu /home/ubuntu/.bashrc /home/ubuntu/.profile

# ssh hardening + key auth
cat >> /etc/ssh/sshd_config <<EOT
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no
UsePAM yes
EOT

systemctl restart ssh

# docker startup
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker
EOF

  tags = {
    Name = "clickops-ec2-qa"
  }
}