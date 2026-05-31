terraform {
  backend "s3" {
    bucket         = "clickops-terraform-state-prd"
    key            = "prd/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
