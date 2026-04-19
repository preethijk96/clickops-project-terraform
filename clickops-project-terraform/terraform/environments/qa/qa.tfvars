region         = "ap-south-1"
key_name = "dev"
ami            = "ami-0f5ee92e2d63afc18"
instance_type  = "t3.micro"

bucket_name = "clickops-bucket-qa"
secret_name = "mongo-creds-qa"

repo_name   = "clickops-app"
environment = "qa"
ecr_name    = "clickops-ecr-qa"