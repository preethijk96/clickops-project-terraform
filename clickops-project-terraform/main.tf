

module "environment" {
 source = "./terraform/environments/dev"

  region          = var.region
  instance_type   = var.instance_type
  vpc_name        = var.vpc_name
  subnet_name     = var.subnet_name
  sg_name         = var.sg_name
  instance_name   = var.instance_name
  iam_role        = var.iam_role
  bucket_name     = var.bucket_name
  repo_name       = var.repo_name
  secret_name     = var.secret_name
  cidr_block      = var.cidr_block
  subnet_cidr     = var.subnet_cidr
  key_name        = var.key_name
  mongo_username  = var.mongo_username
  mongo_password  = var.mongo_password
}