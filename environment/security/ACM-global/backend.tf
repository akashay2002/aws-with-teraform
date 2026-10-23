terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-32999"
    key    = "Security/Ak/Prod/ACM/terraform.tfstate"
    region = "ap-south-1"
  }
}