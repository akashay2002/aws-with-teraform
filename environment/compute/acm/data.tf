data "terraform_remote_state" "dns_backend" {
  backend = "s3"

  config = {

    bucket = "terraform-backend-bucket-s3-32999" # this must be your s3 bucket name
    key    = "global/dns/space9/terraform.tfstate"
    region = "ap-south-1"

  }
}