provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  cidr_block  = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  vpc_name    = "dev-vpc"
  subnet_name = "dev-subnet"
}

module "iam" {
  source = "../../modules/iam"
  role_name = "dev-role"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

module "ecr" {
  source      = "../../modules/ecr"
  ecr_name    = "clickops"
  environment = "dev"
}

module "secrets" {
  source      = "../../modules/secrets"
  secret_name = "mongo-creds"
}

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
  secret_name = var.secret_name
  bucket_name = var.bucket_name   

  frontend_image = module.ecr.frontend_repo_url
  backend_image  = module.ecr.backend_repo_url
}