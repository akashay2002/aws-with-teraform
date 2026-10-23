# Data Sources for VPC Peering Demo

# Data source to get available AZs in Primary region
data "aws_availability_zones" "mumbai_vpc" {

  state    = "available"
}

# Data source to get available AZs in Secondary region
data "aws_availability_zones" "singapore_vpc" {

  state    = "available"
}
data "aws_availability_zones" "virginia_vpc" {

  state    = "available"
}

# Data source for Mumbai vpc region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "mumbai_vpc_instance_ami" {

  most_recent = true

  #We restricted AMI discovery using official publisher account IDs to ensure trusted image sourcing and avoid accidental deployment of unverified public AMIs.”
  owners      = ["099720109477"] # Canonical (Ubuntu)

#  Common Official Owner IDs
# Ubuntu (Canonical)
# 099720109477
# Amazon Linux
# 137112412989
# Red Hat
# 309956199498

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Data source for Singapore Vpc region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "singapore_vpc_instance_ami" {
    provider = aws.singapore

  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)
  # you can explore more https://documentation.ubuntu.com/aws/aws-how-to/instances/find-ubuntu-images/

  # tou can aslo run this commands aws ec2 describe-images \ --owners 099720109477 \ --region ap-southeast-1

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
# Data source for Virginia Vpc region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "virginia_vpc_instance_ami" {
    provider = aws.virginia

  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)
  # you can explore more https://documentation.ubuntu.com/aws/aws-how-to/instances/find-ubuntu-images/

  # tou can aslo run this commands aws ec2 describe-images \ --owners 099720109477 \ --region us-east-1

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}