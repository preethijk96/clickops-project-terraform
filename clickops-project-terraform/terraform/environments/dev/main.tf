provider "aws" {
  region = var.region
}

############################
# VPC
############################
module "vpc" {
  source      = "../../modules/vpc"
  cidr_block  = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  vpc_name    = "clickops-vpc-dev"
  subnet_name = "clickops-subnet-dev"
}

############################
# IAM
############################
module "iam" {
  source    = "../../modules/iam"
  role_name = "clickops-role-dev"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

############################
# S3
############################
module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
}

############################
# ECR
############################
module "ecr" {
  source      = "../../modules/ecr"
  repo_name   = var.ecr_name
  environment = "dev"
}

############################
# SECRETS
############################
module "secrets" {
  source = "../../modules/secrets"

  secret_name = var.secret_name
  username    = "admin"
  password    = "password123"
  host        = "mongodb"
  port        = 27017
  environment = "dev"
}

############################
# EC2
############################
module "ec2" {
  source = "../../modules/ec2"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id

  sg_name = "clickops-sg-dev"

  ec2_name      = "clickops-ec2-dev"
  key_name      = var.key_name
  ami           = var.ami
  instance_type = var.instance_type

  instance_profile = module.iam.instance_profile

  region      = var.region
  bucket_name = var.bucket_name
  secret_name = var.secret_name

  frontend_image = module.ecr.frontend_repo_url
  backend_image  = module.ecr.backend_repo_url
}