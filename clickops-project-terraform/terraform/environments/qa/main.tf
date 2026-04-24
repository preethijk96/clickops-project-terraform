provider "aws" {
 region = var.region
}

#################################
# Auto discover default network
#################################

data "aws_vpc" "default" {
 default = true
}

data "aws_subnets" "default" {
 filter {
   name   = "vpc-id"
   values = [data.aws_vpc.default.id]
 }
}

#################################
# IAM
#################################

module "iam" {
 source = "../../modules/iam"

 role_name = "clickops-ec2-role"

 policy_arns = [
  "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
 ]
}

#################################
# S3
#################################

module "s3" {
 source      = "../../modules/s3"
 bucket_name = var.bucket_name
}

#################################
# ECR
#################################

module "ecr" {
 source    = "../../modules/ecr"
 repo_name = var.ecr_name
}

#################################
# Secrets
#################################

module "secrets" {

 source = "../../modules/secrets"

 secret_name = "clickops-sm-${var.environment}"

 username = "admin"
 password = "Password123"

 host = "mongodb"
 port = "27017"

 environment = var.environment
}

#################################
# EC2
#################################

module "ec2" {

 source = "../../modules/ec2"

 ami           = var.ami
 instance_type = var.instance_type
 key_name      = var.key_name

 # Fully automatic
 subnet_id = data.aws_subnets.default.ids[0]
 vpc_id    = data.aws_vpc.default.id

 sg_name = "clickops-sg-qa"

 instance_profile = module.iam.instance_profile

instance_name = var.instance_name

 root_volume_size = var.root_volume_size
}