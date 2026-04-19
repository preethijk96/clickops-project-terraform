variable "region" {}
variable "key_name" {}
variable "ami" {}
variable "instance_type" {}

variable "bucket_name" {}
variable "secret_name" {}

variable "ecr_name" {
  type = string
}
variable "repo_name" {
  type = string
}

variable "environment" {
  type = string
}
variable "secret_name" {
  type = string
}