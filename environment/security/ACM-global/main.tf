module "acm_module" {
  source = "../../../Modules/Security/ACM-Global"
  domain_name = var.domain_name
  aws_region = var.aws_region
  
}