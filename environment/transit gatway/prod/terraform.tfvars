
vpc_cidrs = [
  "10.0.0.0/16",
  "172.31.0.0/16",
  "192.168.0.0/16"
]

aws_region_1 = "ap-south-1"
aws_region_2 = "ap-southeast-1"
aws_region_3 = "us-east-1"

environment = "Prod"

m_public_subnet_cidrs = ["10.0.1.0/24"]
m_public_azs          = ["ap-south-1a"]

s_public_subnet_cidrs = ["172.31.1.0/24"]
s_public_azs          = ["ap-southeast-1a"]

v_public_subnet_cidrs = ["192.168.1.0/24"]
v_public_azs          = ["us-east-1a"]



  singapore_vpc_instance_key_name = "Sonu-Singapore-key"
  instance_type = "t3.micro"
  mumbai_vpc_region = "ap-south-1"

  mumbai_vpc_instance_key_name = "sonu-key"
  virginia_vpc_instance_key_name = "Sonu-Virginia-Key"
  virginia_vpc_region = "us-east-1"
 singapore_vpc_region = "ap-southeast-1"
