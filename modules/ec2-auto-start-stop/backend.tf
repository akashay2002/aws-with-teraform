terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket-s3-32999"
    key    = "lambada/Akashy/prod/ec2-start-stop/terraform.tfstate"
    region = "ap-south-1"
  }
}