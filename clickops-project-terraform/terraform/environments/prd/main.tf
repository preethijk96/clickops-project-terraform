############################################
# PROVIDER (ASSUME ROLE)
############################################

provider "aws" {
  region = var.region

  
}

############################################
# IAM ROLE FOR EC2
############################################

module "iam" {
  source    = "../../modules/iam"
  role_name = "clickops-ec2-role-dev"

  policy_arns = [
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

############################################
# VPC
############################################

module "vpc" {
  source       = "../../modules/vpc"
  cidr_block   = "10.0.0.0/16"
  subnet_cidr  = "10.0.1.0/24"
  vpc_name     = var.vpc_name
  subnet_name  = var.subnet_name
}

############################################
# ECR REPOSITORY (CREATE FIRST)
############################################

module "ecr" {
  source = "../../modules/ecr"

  ecr_name    = var.ecr_name
  repo_name   = var.ecr_name
  environment = "dev"
}
############################################
# EC2 INSTANCE
############################################

module "ec2" {
  source = "../../modules/ec2"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  sg_name   = var.sg_name

  ec2_name      = var.ec2_name
  key_name      = var.key_name
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = var.instance_type

  instance_profile = module.iam.instance_profile

  region      = var.region
  bucket_name = var.bucket_name
  secret_name = var.secret_name

  # ✅ CORRECT ECR USAGE
  frontend_image = module.ecr.frontend_repo_url
  backend_image  = module.ecr.backend_repo_url
}

############################################
# S3 BUCKET
############################################

module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
}

############################################
# SECRETS MANAGER
############################################

module "secrets" {
  source = "../../modules/secrets"

  secret_name = var.secret_name

  username    = "admin"
  password    = "password123"
  host        = "mongodb"
  port        = "27017"
  environment = "dev"
}