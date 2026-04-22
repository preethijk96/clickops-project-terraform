provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  cidr_block  = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"

  vpc_name    = "clickops-vpc-dev"
  subnet_name = "clickops-subnet-dev"
}

module "iam" {
  source = "../../modules/iam"
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
}

module "ecr" {
  source    = "../../modules/ecr"
  repo_name = var.ecr_name
}

module "secrets" {
  source      = "../../modules/secrets"
  secret_name = var.secret_name
}

module "ec2" {
  source = "../../modules/ec2"

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = module.vpc.subnet_id
  vpc_id    = module.vpc.vpc_id

  instance_profile = module.iam.instance_profile

  sg_name = "clickops-sg-dev"

  instance_name = "clickops-ec2-dev"
}