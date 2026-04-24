module "iam" {
 source = "../iam"
 environment = var.environment
}

module "s3" {
 source = "../s3"
 bucket_name = "clickops-bucket-${var.environment}"
 environment = var.environment
}

module "ecr" {
 source = "../ecr"
 ecr_name = "clickops-ecr-${var.environment}"
 environment = var.environment
}

module "secrets" {
 source = "../secrets"
 secret_name = "mongo-creds-${var.environment}"
 environment = var.environment
}

module "ec2" {
  source = "../../modules/ec2"

  ami              = var.ami
  instance_type    = var.instance_type
  key_name         = var.key_name
  instance_name    = "clickops-ec2-${var.environment}"
  root_volume_size = var.root_volume_size

  vpc_id           = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  instance_profile = module.iam.instance_profile
  sg_name          = "clickops-sg-${var.environment}"
}