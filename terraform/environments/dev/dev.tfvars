region = "ap-south-1"

instance_type = "t3.micro"

vpc_name = "clickops-vpc-dev"
subnet_name = "clickops-subnet-dev"
sg_name = "clickops-sg-dev"
instance_name = "clickops-ec2-dev"

iam_role = "clickops-iam-role-dev"
repo_name = "clickops-ecr-dev"

cidr_block = "10.0.0.0/16"
subnet_cidr = "10.0.1.0/24"
key_name = "dev"
mongo_username = "clickops_admin"
mongo_password = "StrongPassword123"


ecr_url     = "031277186489.dkr.ecr.ap-south-1.amazonaws.com/clickops-repo"
bucket_name = "clickops-bucket-preethi"   # your S3 bucket
secret_name = "mongo-secret"