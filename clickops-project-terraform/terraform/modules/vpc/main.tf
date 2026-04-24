resource "aws_vpc" "main" {
 cidr_block = var.cidr_block

 enable_dns_support   = true
 enable_dns_hostnames = true

 tags = {
   Name = var.vpc_name
 }
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id

 tags = {
   Name = "${var.vpc_name}-igw"
 }
}

resource "aws_subnet" "public" {
 vpc_id = aws_vpc.main.id

 cidr_block = var.subnet_cidr

 map_public_ip_on_launch = true

 tags = {
   Name = var.subnet_name
 }
}

resource "aws_route_table" "public_rt" {

 vpc_id = aws_vpc.main.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }

 tags = {
   Name="${var.vpc_name}-rt"
 }

}

resource "aws_route_table_association" "public_assoc" {

 subnet_id      = aws_subnet.public.id
 route_table_id = aws_route_table.public_rt.id

}

resource "aws_security_group_rule" "frontend_ports" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8083
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "backend_ports" {
  type              = "ingress"
  from_port         = 5001
  to_port           = 5003
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}