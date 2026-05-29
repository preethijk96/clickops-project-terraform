region        = "ap-south-1"
key_name      = "dev"
ami           = "ami-0f5ee92e2d63afc18"
instance_type = "t3.micro"

bucket_name = "clickops-bucket-dev"
secret_name = "mongo-creds"

repo_name   = "clickops-app"
environment = "dev"

root_volume_size = 50

instance_name = "clickops-ec2-dev1"

backend_port  = 5001
frontend_port = 8081

vpc_id = "vpc-07d9d8867de4180a8"