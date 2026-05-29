variable "environment" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "root_volume_size" {}
variable "frontend_port" {}
variable "backend_port" {}

variable "instance_name" {}

variable "vpc_id" {
  type = string
}