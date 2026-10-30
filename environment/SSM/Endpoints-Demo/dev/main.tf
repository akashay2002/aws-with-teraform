#################################################
# SECURITY GROUP
#################################################

module "security_group" {

  source = "../../../../Modules/SSM/Vpc-Endpoints/Security-group"

  environment = var.environment

  project_name = var.project_name

  vpc_id = data.terraform_remote_state.vpc_backend.outputs.vpc_id

  vpc_cidr = var.vpc_cidr

  aws_region = var.aws_region
}

#################################################
# S3
#################################################

module "s3" {

  source = "../../../../Modules/SSM/Vpc-Endpoints/s3"

  environment = var.environment

  bucket_name = var.bucket_name

  aws_region = var.aws_region
}

#################################################
# IAM
#################################################

module "iam" {

  source = "../../../../Modules/SSM/Vpc-Endpoints/iam-role"

  environment = var.environment

  bucket_arn = module.s3.bucket_arn

  aws_region = var.aws_region

}

#################################################
# EC2
#################################################

module "ec2" {

  source = "../../../../Modules/SSM/Vpc-Endpoints/Ec2"

  environment = var.environment

  project_name = var.project_name

  instance_type = var.instance_type

  private_subnet_id = data.terraform_remote_state.vpc_backend.outputs.private_subnet_ids[0]

  ec2_security_group_id = module.security_group.ec2_security_group_id

#   depends_on = [
#     module.iam
#   ]
  instance_profile_name = module.iam.instance_profile_name

  aws_region = var.aws_region

}