variable "environment" {
  description = "dev / qa / prd"
}

variable "region" {}
variable "instance_type" {}
variable "vpc_name" {}
variable "subnet_name" {}
variable "sg_name" {}
variable "instance_name" {}
variable "iam_role" {}
variable "bucket_name" {}
variable "repo_name" {}
variable "secret_name" {}
variable "cidr_block" {}
variable "subnet_cidr" {}
variable "key_name" {}

variable "mongo_username" {}
variable "mongo_password" {}
variable "region" {
  default = "ap-south-1"
}

variable "environment" {
  description = "dev / qa / prd"
}
