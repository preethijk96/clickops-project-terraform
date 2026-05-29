variable "secret_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type    = string
  default = "password123"
}

variable "host" {
  type    = string
  default = "mongodb"
}

variable "port" {
  type    = number
  default = 27017
}