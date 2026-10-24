terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-1234"
    key    = "Network/Abhishek/dev/vpc-endpoints/terraform.tfstate"
    region = "ap-south-1"
  }
}