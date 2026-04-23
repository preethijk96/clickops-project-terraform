region        = "ap-south-1"
key_name      = "dev"
ami           = "ami-0f58b397bc5c1f2e8"
instance_type = "t3.micro"

bucket_name = "clickops-bucket-dev"
secret_name = "mongo-creds"

repo_name   = "clickops-app"
environment = "dev"
ecr_name    = "clickops-ecr-dev"
root_volume_size = 20






