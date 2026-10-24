terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-32999"
    key    = "Compute/akashy/dev/vpc-endpoints/terraform.tfstate"
    region = "ap-south-1"
  }
}