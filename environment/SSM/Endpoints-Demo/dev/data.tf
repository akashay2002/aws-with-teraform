data "terraform_remote_state" "vpc_backend" {
 backend = "s3"

  config = {
   bucket = "terraform-backend-bucket-s3-32999"
    key    = "Network/Akashy/dev/vpc-endpoints/terraform.tfstate"
    region = "ap-south-1"

}
}