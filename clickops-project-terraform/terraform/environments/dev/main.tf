provider "aws" {
  region = var.region
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

  
subnet_id = "subnet-0be968429cbed7843"
vpc_id    = "vpc-063aa8818d9de4b22"
  instance_profile = module.iam.instance_profile

  sg_name = "clickops-sg-dev"

  instance_name = "clickops-ec2-dev"
}