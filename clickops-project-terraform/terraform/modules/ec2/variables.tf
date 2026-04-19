variable "sg_name" {}
variable "vpc_id" {}
variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "key_name" {}
variable "instance_profile" {}
variable "ec2_name" {}

variable "region" {}

variable "bucket_name" {}
variable "secret_name" {}
variable "frontend_image" {}
variable "backend_image" {}
variable "secret_string" {
  type      = string
  sensitive = true
}
