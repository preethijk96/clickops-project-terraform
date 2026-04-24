resource "aws_security_group" "app_sg" {
  name        = "clickops-sg"
  description = "Allow app traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend Ports
  ingress {
    from_port   = 5001
    to_port     = 5003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend Ports
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
}