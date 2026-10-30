terraform {
  backend "s3" {

    bucket = "terraform-backend-bucket-s3-32999" # this must be your s3 bucket name
    key    = "compute/fctp/dev/lt/terraform.tfstate"
    region = "ap-south-1"
  }
}