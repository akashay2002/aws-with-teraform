terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-32999"
    key    = "DNS/Akashy/hosted_zone/terraform.tfstate"
    region = "ap-south-1"
  }
}