region = "ap-south-1"

vpc_name       = "clickops-vpc-prd"
subnet_name    = "clickops-subnet-prd"
sg_name        = "clickops-sg-prd"
instance_name  = "clickops-ec2-prd"

iam_role   = "clickops-iam-role-prd"
bucket_name = "clickops-s3-prd-12345"

repo_name   = "clickops-ecr-prd"
secret_name = "clickops-sm-prd"

cidr_block   = "10.2.0.0/16"
subnet_cidr  = "10.2.1.0/24"
key_name     = "prd"