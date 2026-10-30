terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-1234"
    key    = "Networking/Abhi/prod/Trinsit-Gateway/terraform.tfstate"
    region = "ap-south-1"
  }
}