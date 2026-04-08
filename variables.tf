A production-ready 3-tier Python Employee Application deployed on AWS using Terraform (Infrastructure as Code) with support for DEV, QA, and PRD environments.

🏗️ Architecture
Browser
   │
   ▼
EC2 Instance (Dockerized)
┌──────────────────────────────────────┐
│  Frontend (Nginx - Port 80)          │
│          │                           │
│          ▼                           │
│  Backend (Flask - Port 3000)         │
│          │                           │
│          ▼                           │
│     MongoDB (Container)              │
└──────────────────────────────────────┘
        │                │
        ▼                ▼
     Amazon S3      Secrets Manager
   (Image Upload)   (DB Credentials)

            ▼
        Amazon ECR
      (Docker Images)
🔐 Secrets Flow (No Hardcoding)
terraform apply
      │
      ▼
TF_VAR_mongo_username / password
      │
      ▼
Stored in AWS Secrets Manager
      │
      ▼
EC2 (via IAM Role) reads secret
      │
      ▼
Backend (Flask) uses credentials securely
📁 Project Structure
clickops-project/
│
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── sg/
│   │   ├── iam/
│   │   ├── ec2/
│   │   ├── s3/
│   │   ├── ecr/
│   │   └── secrets/
│   │
│   ├── environments/
│   │   ├── dev/
│   │   ├── qa/
│   │   └── prd/
│
├── app/
│   ├── backend/
│   ├── frontend/
│
├── docker/
│   └── docker-compose.yml
│
└── README.md
⚙️ Environment Configuration
Setting	DEV	QA	PRD
Instance Type	t3.micro	t3.small	m7i-flex.large
Storage	10 GB	20 GB	30 GB
Region	ap-south-1	ap-south-1	ap-south-1
AZ	ap-south-1a	ap-south-1b	ap-south-1c
VPC CIDR	10.0.0.0/16	10.1.0.0/16	10.2.0.0/16
🏷️ Resource Naming Convention
Resource	DEV	QA	PRD
VPC	clickops-vpc-dev	clickops-vpc-qa	clickops-vpc-prd
Subnet	clickops-subnet-dev	clickops-subnet-qa	clickops-subnet-prd
Security Group	clickops-sg-dev	clickops-sg-qa	clickops-sg-prd
EC2	clickops-ec2-dev	clickops-ec2-qa	clickops-ec2-prd
IAM Role	clickops-iam-role-dev	clickops-iam-role-qa	clickops-iam-role-prd
S3 Bucket	clickops-s3-dev	clickops-s3-qa	clickops-s3-prd
Secrets Manager	clickops-sm-dev	clickops-sm-qa	clickops-sm-prd
ECR	clickops-ecr-dev	clickops-ecr-qa	clickops-ecr-prd
🛠️ Prerequisites

Install on your EC2 / local machine:

# Terraform
sudo apt install -y terraform

# Docker
sudo apt install -y docker.io docker-compose

# AWS CLI
sudo apt install -y awscli
🚀 Deployment Steps
1️⃣ Clone Repository
git clone https://github.com/<your-username>/clickops-project.git
cd clickops-project
2️⃣ Set Secrets (VERY IMPORTANT)
export TF_VAR_mongo_username="clickops_admin"
export TF_VAR_mongo_password="StrongPassword123"
3️⃣ Deploy Infrastructure
cd terraform/environments/dev

terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
4️⃣ Push Docker Images to ECR
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin <ECR_URL>

docker build -t backend ./app/backend
docker tag backend:latest <ECR_URL>:be-v1
docker push <ECR_URL>:be-v1

docker build -t frontend ./app/frontend
docker tag frontend:latest <ECR_URL>:fe-v1
docker push <ECR_URL>:fe-v1
5️⃣ Apply Again (Important)
terraform apply -var-file=dev.tfvars
6️⃣ Access Application
http://<EC2-PUBLIC-IP>
📡 API Endpoints
Method	Endpoint	Description
GET	/	Health Check
POST	/add	Add Employee
GET	/list	List Employees
🧹 Destroy Infrastructure
terraform destroy -var-file=dev.tfvars