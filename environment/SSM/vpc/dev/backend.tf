terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-32999"
    key    = "Network/Akashy/dev/vpc-endpoints/terraform.tfstate"
    region = "ap-south-1"
  }
}