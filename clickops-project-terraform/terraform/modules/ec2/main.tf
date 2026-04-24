resource "aws_security_group" "app_sg" {
 name = "clickops-${var.environment}-sg"

 ingress {
   from_port = 22
   to_port   = 22
   protocol  = "tcp"
   cidr_blocks=["0.0.0.0/0"]
 }

 ingress {
   from_port = var.frontend_port
   to_port   = var.frontend_port
   protocol  = "tcp"
   cidr_blocks=["0.0.0.0/0"]
 }

 ingress {
   from_port = var.backend_port
   to_port   = var.backend_port
   protocol  = "tcp"
   cidr_blocks=["0.0.0.0/0"]
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

 root_block_device {
   volume_size = var.root_volume_size
   volume_type = "gp3"
 }

 user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y docker.io openssh-server

systemctl enable ssh
systemctl restart ssh

usermod -s /bin/bash ubuntu

mkdir -p /home/ubuntu/.ssh

cat <<KEY >> /home/ubuntu/.ssh/authorized_keys
PASTE_YOUR_PUBLIC_KEY_HERE
KEY

chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

systemctl restart ssh

usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker
EOF

 tags = {
   Name = "clickops-ec2-${var.environment}"
 }
}

output "public_ip" {
 value = aws_instance.app.public_ip
}