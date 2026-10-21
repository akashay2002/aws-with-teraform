
variable "vpc_cidrs" {
  type = list(string)
}
variable "aws_region_1" {
  type = string
}
variable "aws_region_2" {
  type = string
}
variable "aws_region_3" {
  type = string
}
variable "environment" {
  type = string
}
variable "m_public_subnet_cidrs" {
  type = list(string)
}
variable "m_public_azs" {
  type = list(string)
}
variable "s_public_subnet_cidrs" {
  type = list(string)
}
variable "s_public_azs" {
  type = list(string)
}
variable "v_public_subnet_cidrs" {
  type = list(string)
}
variable "v_public_azs" {
  type = list(string)
}
variable "instance_type" {
  type = string
}
variable "mumbai_vpc_instance_key_name" {
  type = string
}
variable "mumbai_vpc_region" {
  type = string
}
variable "singapore_vpc_instance_key_name" {
  type = string
}
variable "singapore_vpc_region" {
  type = string
}
variable "virginia_vpc_region" {
  type = string
}
variable "virginia_vpc_instance_key_name" {
  type = string
}
# variable "enable_dns_support" {
#   type = string
# }
# variable "enable_dns_hostnames" {
#   type = list(string)
# }
# variable "map_public_ip_on_launch" {
#   type = string
# }
