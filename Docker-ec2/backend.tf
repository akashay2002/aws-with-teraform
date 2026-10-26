terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-32999"
    key    = "compute/Akashy/docker-automation/terraform.tfstate"
    region = "ap-south-1"
  }
}