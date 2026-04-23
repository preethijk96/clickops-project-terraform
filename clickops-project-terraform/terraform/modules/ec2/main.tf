resource "aws_security_group" "sg" {

  name   = var.sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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


resource "aws_instance" "ec2" {

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  iam_instance_profile = var.instance_profile

  associate_public_ip_address = true


  
  root_block_device {
      volume_size = var.root_volume_size
      volume_type = "gp3"
      encrypted   = true
  }
  

  tags = {
    Name = var.instance_name
  }

}

output "instance_public_ip" {
 value = aws_instance.ec2.public_ip
}
