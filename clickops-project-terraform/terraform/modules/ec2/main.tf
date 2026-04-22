resource "aws_security_group" "sg" {
  name   = var.sg_name
  vpc_id = var.vpc_id

 ingress {
   from_port = 22
   to_port   = 22
   protocol  = "tcp"
   cidr_blocks=["0.0.0.0/0"]
 }

 ingress {
   from_port = 80
   to_port   = 80
   protocol  = "tcp"
   cidr_blocks=["0.0.0.0/0"]
 }

 ingress {
   from_port = 5000
   to_port   = 5000
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