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
  environment = "dev"
}

module "secrets" {
  source      = "../../modules/secrets"
  secret_name = var.secret_name
  environment = "dev"   # ✅ YOU WERE MISSING THIS EARLIER

  username = var.mongo_username
  password = var.mongo_password
  host     = "mongodb"
  port     = 27017
}
data "aws_secretsmanager_secret_version" "mongo" {
  secret_id = var.secret_name
}

locals {
  mongo_creds = jsondecode(data.aws_secretsmanager_secret_version.mongo.secret_string)
}


module "ec2" {
  source = "../../modules/ec2"

  instance_name = var.instance_name
  subnet_id     = module.vpc.subnet_id
  sg_id         = module.sg.sg_id
  iam_profile   = module.iam.instance_profile   # ✅ CONNECTED
  key_name      = var.key_namemongo_username = var.mongo_username
  mongo_username = local.mongo_creds.username
  mongo_password = local.mongo_creds.password
  ecr_url        = var.ecr_url
  bucket_name = var.bucket_name
  secret_name = var.secret_name

}