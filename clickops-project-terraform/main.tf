terraform {
  required_version = ">=1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  environments = {
    dev = {
      frontend_port = 8081
      backend_port  = 5001
    }

    qa = {
      frontend_port = 8082
      backend_port  = 5002
    }

    prd = {
      frontend_port = 8083
      backend_port  = 5003
    }
  }
}

module "clickops" {
  for_each = local.environments

  source = "./modules/environment"

  environment      = each.key
  frontend_port    = each.value.frontend_port
  backend_port     = each.value.backend_port

  ami              = "ami-0f5ee92e2d63afc18"
  instance_type    = "t3.micro"
  key_name         = "dev"
  root_volume_size = 20
}