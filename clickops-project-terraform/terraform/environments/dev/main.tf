provider "aws" {
  region = var.region
}



module "iam" {
 source = "../../modules/iam"

 role_name = "clickops-ec2-role"

 policy_arns = [
   "arn:aws:iam::aws:policy/AmazonS3FullAccess",
   "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
 ]
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

 subnet_id = data.aws_subnets.default.ids[0]
 vpc_id    = data.aws_vpc.default.id

 sg_name = "dev-sg"

 instance_profile = module.iam.instance_profile_name

 instance_name = "dev-server"

 root_volume_size = 20
}