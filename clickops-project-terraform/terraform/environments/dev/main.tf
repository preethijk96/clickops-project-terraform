module "iam" {
  source      = "../../modules/iam"
  environment = var.environment
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "clickops-bucket-${var.environment}"
  
}

module "ecr" {
  source    = "../../modules/ecr"

  repo_name = "clickops-ecr-${var.environment}"
}
module "secrets" {
  source = "../../modules/secrets"

  secret_name = "mongo-creds-${var.environment}"
  environment = var.environment

  username = "admin"
  password = "password123"
  host     = "mongodb"
  port     = 27017
}

module "ec2" {
  source = "../../modules/ec2"

  instance_name    = var.instance_name
  environment      = var.environment

  ami              = var.ami
  instance_type    = var.instance_type
  key_name         = var.key_name
  root_volume_size = var.root_volume_size

  frontend_port    = var.frontend_port
  backend_port     = var.backend_port

  vpc_id           = var.vpc_id
}