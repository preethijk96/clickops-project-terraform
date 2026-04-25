region         = "ap-south-1"
key_name = "dev"
ami           = "ami-0f5ee92e2d63afc18"
instance_type  = "t3.micro"

bucket_name = "clickops-bucket-qa"
secret_name = "mongo-creds-qa"

repo_name   = "clickops-app"
environment = "qa"
ecr_name    = "clickops-ecr-qa"
root_volume_size = 50

instance_name = "clickops-ec2-qa"

backend_port  = 5003
frontend_port = 8083






