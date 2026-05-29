# ClickOps Multi-Environment 3-Tier Application on AWS using Terraform

A production-ready **3-tier Python Student Entry Application** deployed on **AWS using Terraform (Infrastructure as Code)** with support for **DEV, QA and PRD** environments.

---

# Architecture

```text
Browser
   |
   v
EC2 Instance (Dockerized)
---------------------------------------------------
Frontend (Nginx)
   |
   v
Backend (Flask API)
   |
   +-----------------> MongoDB (Student Data)
   |
   +-----------------> Amazon S3 (Image Uploads)

Provisioned using Terraform Modules
---------------------------------------------------
EC2
S3
IAM
ECR
Secrets Manager
---------------------------------------------------
```

---

# Features

- Multi Environment Deployment (DEV / QA / PRD)
- Terraform Modular Infrastructure
- Dockerized Application
- Student Form Web Application
- MongoDB Integration
- S3 Image Uploads
- AWS Secrets Manager Integration
- Amazon ECR for Container Images
- Environment-specific isolation
- Dynamic Frontend-to-Backend API Integration

---

# Tech Stack

- Python Flask
- MongoDB
- HTML / CSS / JavaScript
- Nginx
- Docker / Docker Compose
- Terraform
- AWS EC2
- AWS S3
- AWS ECR
- AWS Secrets Manager

---

# Project Structure

```bash
clickops-project-terraform/
│
├── app/
│   ├── backend/
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   │
│   └── frontend/
│       ├── Dockerfile
│       └── index.html
│
├── docker/
│   └── docker-compose.yml
│
├── terraform/
│   ├── main.tf
│   │
│   ├── modules/
│   │   ├── ec2/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │
│   │   ├── ecr/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │
│   │   ├── iam/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │
│   │   ├── s3/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │
│   │   └── secrets/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   └── environments/
│       ├── dev/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   └── dev.tfvars
│       │
│       ├── qa/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   └── qa.tfvars
│       │
│       └── prd/
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           └── prd.tfvars
│
├── .gitignore
└── README.md
```

---

# Environment Configuration

| Setting | DEV | QA | PRD |
|--------|-----|----|-----|
Region | ap-south-1 | ap-south-1 | ap-south-1
AMI | ami-0f5ee92e2d63afc18 | ami-0f5ee92e2d63afc18 | ami-0f5ee92e2d63afc18
Instance Type | t3.micro | t3.micro | t3.micro
Root Volume | 50 GB | 50 GB | 50 GB
Backend Port | 5001 | 5002 | 5003
Frontend Port | 8081 | 8082 | 8083

---

# Resource Naming Convention

## DEV

```text
Instance Name  : clickops-ec2-dev1
Bucket         : clickops-bucket-dev
Secret Name    : mongo-creds
ECR Repository : clickops-ecr-dev
Environment    : dev
```

## QA

```text
Instance Name  : clickops-ec2-qa
Bucket         : clickops-bucket-qa
Secret Name    : mongo-creds-qa
ECR Repository : clickops-ecr-qa
Environment    : qa
```

## PRD

```text
Instance Name  : clickops-ec2-prd1
Bucket         : clickops-bucket-prd
Secret Name    : mongo-creds-prd
ECR Repository : clickops-ecr-prd
Environment    : prd
```

---

# Docker Containers

## Development

```bash
frontend-dev
backend-dev
mongodb-dev
```

## QA

```bash
frontend-qa
backend-qa
mongodb-qa
```

## Production

```bash
frontend-prd
backend-prd
mongodb-prd
```

---

# Port Mapping

| Service | Port |
|--------|------|
Frontend Dev | 8081
Frontend QA | 8082
Frontend PRD | 8083
Backend Dev | 5001
Backend QA | 5002
Backend PRD | 5003

---

# Application Flow

```text
User submits:
Name
Age
Image

Frontend
   |
POST /add
   |
Backend Flask
   |
Uploads image to S3
Stores record in MongoDB

GET /list
Returns all records
Displays in frontend
```

---

# Prerequisites

Install dependencies:

```bash
sudo apt update

sudo apt install terraform -y

sudo apt install docker.io docker-compose -y

sudo apt install awscli -y
```

---

# Clone Repository

```bash
git clone https://github.com/preethijk96/clickops-project-terraform.git

cd clickops-project-terraform
```

---

# Terraform Deployment

## DEV

```bash
cd terraform/environments/dev

terraform init

terraform plan -var-file=dev.tfvars

terraform apply -var-file=dev.tfvars
```

---

## QA

```bash
cd terraform/environments/qa

terraform init

terraform apply -var-file=qa.tfvars
```

---

## PRD

```bash
cd terraform/environments/prd

terraform init

terraform apply -var-file=prd.tfvars
```

---

# Docker Deployment

Build images:

## Backend

```bash
docker build -t backend ./app/backend
```

## Frontend

```bash
docker build -t frontend ./app/frontend
```

Run:

```bash
cd docker

docker-compose up -d
```

Verify:

```bash
docker ps
```

---

# Push Images to ECR

Login:

```bash
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin <ECR_URL>
```

Push Backend:

```bash
docker tag backend:latest <ECR_URL>:backend-v1

docker push <ECR_URL>:backend-v1
```

Push Frontend:

```bash
docker tag frontend:latest <ECR_URL>:frontend-v1

docker push <ECR_URL>:frontend-v1
```

---

# API Endpoints

## Health Check

```http
GET /
```

Sample Response

```json
{
"environment":"prd",
"bucket":"clickops-bucket-prd",
"database":"clickops-prd"
}
```

---

## Add Student

```http
POST /add
```

Stores:
- name
- age
- image

---

## List Students

```http
GET /list
```

Returns:

```json
[
{
"name":"santhi",
"age":"37",
"image":"s3-url"
}
]
```

---

# Verify MongoDB

```bash
docker exec -it mongodb-prd mongosh
```

```javascript
use clickops-prd

show collections

db.users.find().pretty()
```

---

# Verify S3 Upload

```bash
aws s3 ls s3://clickops-bucket-prd/
```

---

# Access Application

## DEV

```bash
http://<ec2-public-ip>:8081
```

## QA

```bash
http://<ec2-public-ip>:8082
```

## PRD

```bash
http://<ec2-public-ip>:8083
```

---

# Useful Commands

Check containers:

```bash
docker ps
```

Check logs:

```bash
docker logs backend-prd
```

Restart containers:

```bash
docker-compose restart
```

Rebuild frontend:

```bash
docker build --no-cache -t docker_frontend-prd ./app/frontend
```

---

# Secrets Flow

```text
Terraform Apply
   |
Secrets stored in AWS Secrets Manager
   |
IAM Role grants EC2 access
   |
Flask backend reads secrets securely
```

---

# Destroy Infrastructure

DEV

```bash
terraform destroy -var-file=dev.tfvars
```

QA

```bash
terraform destroy -var-file=qa.tfvars
```

PRD

```bash
terraform destroy -var-file=prd.tfvars
```

---

# Author

Preethi JK

GitHub:
https://github.com/preethijk96

Project:
ClickOps Multi-Environment Terraform Application