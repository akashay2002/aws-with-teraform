module "vpc_module" {
  source = "../../../modules/vpc-peering"

  vpc_cidrs = var.vpc_cidrs

  aws_region_1 = var.aws_region_1
  aws_region_2 = var.aws_region_2
  aws_region_3 = var.aws_region_3

  environment = var.environment

  m_public_subnet_cidrs = var.m_public_subnet_cidrs
  m_public_azs          = var.m_public_azs

  s_public_subnet_cidrs = var.s_public_subnet_cidrs
  s_public_azs          = var.s_public_azs

  v_public_subnet_cidrs = var.v_public_subnet_cidrs
  v_public_azs          = var.v_public_azs

  singapore_vpc_instance_key_name = var.singapore_vpc_instance_key_name
  instance_type = var.instance_type
  mumbai_vpc_region = var.mumbai_vpc_region

  mumbai_vpc_instance_key_name = var.mumbai_vpc_instance_key_name
  virginia_vpc_instance_key_name = var.virginia_vpc_instance_key_name

  virginia_vpc_region = var.virginia_vpc_region
 singapore_vpc_region = var.singapore_vpc_region

}

