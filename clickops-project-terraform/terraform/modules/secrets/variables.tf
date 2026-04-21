variable "secret_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "host" {
  type = string
}

variable "port" {
  type = number
}
variable "environment" {
  type = string
}
variable "bucket_name" {
  default = "your-s3-bucket-name"
}