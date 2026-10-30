terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "mumbai"
  region = var.aws_region_1
}

provider "aws" {
  alias  = "singapore"
  region = var.aws_region_2
}

provider "aws" {
  alias  = "virginia"
  region = var.aws_region_3
}