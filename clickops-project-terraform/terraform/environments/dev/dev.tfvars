region        = "ap-south-1"

vpc_name      = "clickops-vpc-dev"
subnet_name   = "clickops-public-subnet-dev"
sg_name       = "clickops-sg-dev"
ec2_name      = "clickops-ec2-dev"

bucket_name   = "clickops-bucket-preethi"
ecr_name      = "clickops-ecr-dev"
secret_name   = "clickops-sm-dev"

key_name      = "dev"
iam_role      = "clickops-iam-role-dev"   # must already exist

instance_type = "t3.micro"