provider "aws" {
  region = var.region
}

module "vpc" {
  source       = "../../modules/vpc"
  vpc_name     = var.vpc_name
  cidr_block   = var.cidr_block
  subnet_name  = var.subnet_name
  subnet_cidr  = var.subnet_cidr
}

module "sg" {
  source  = "../../modules/sg"
  sg_name = var.sg_name
  vpc_id  = module.vpc.vpc_id
}

module "iam" {
  source    = "../../modules/iam"
  role_name = var.iam_role
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.bucket_name
}

module "ecr" {
  source      = "../../modules/ecr"
  repo_name   = var.repo_name
  environment = "dev"   # ✅ REQUIRED here
}

module "secrets" {
  source      = "../../modules/secrets"
  secret_name = var.secret_name
  environment = "dev"   # 🔥 ADD THIS

  username = var.mongo_username
  password = var.mongo_password
  host     = "mongodb"
  port     = 27017
}

module "ec2" {
  source          = "../../modules/ec2"
  instance_name   = var.instance_name
  subnet_id       = module.vpc.subnet_id
  sg_id           = module.sg.sg_id
  iam_profile     = module.iam.instance_profile
  key_name        = var.key_name

  ecr_url     = module.ecr.repository_url
  bucket_name = var.bucket_name
  secret_name = var.secret_name
}