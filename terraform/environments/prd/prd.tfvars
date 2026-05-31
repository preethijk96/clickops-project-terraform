region         = "ap-south-1"
key_name = "dev"
ami           = "ami-0f5ee92e2d63afc18"
instance_type  = "t3.small"

bucket_name = "clickops-bucket-prd"
secret_name = "mongo-creds-prd"

repo_name   = "clickops-app"
environment = "prd"
ecr_name    = "clickops-ecr-prd"
root_volume_size = 20

instance_name = "clickops-ec2-prd1"

backend_port  = 5003
frontend_port = 8083
vpc_id = "vpc-0daf87b6badf3841a"






