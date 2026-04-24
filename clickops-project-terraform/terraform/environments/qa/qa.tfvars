region         = "ap-south-1"
key_name = "dev"
ami            = "ami-0f5ee92e2d63afc18"
instance_type  = "t3.medium"

bucket_name = "clickops-bucket-qa"

secret_name = "clickops-qa-secret"
repo_name   = "clickops-app"
environment = "qa"
ecr_name    = "clickops-ecr-qa"
instance_name = "clickops-ec2-qa1"

backend_port  = 5002
frontend_port = 8082

