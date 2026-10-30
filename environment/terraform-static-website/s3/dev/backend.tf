terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-32999"
    key    = "Networking/AK/dev/vpc-peering/terraform.tfstate"
    region = "ap-south-1"
  }
}