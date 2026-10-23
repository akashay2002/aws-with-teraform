module "static_website" {
  source = "../../module/static-website"

  bucket_name = var.bucket_name
  aws_region  = var.aws_region
}