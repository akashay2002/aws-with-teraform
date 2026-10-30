#################################################
# LOCAL TAGS
#################################################
locals {

  common_tags = {

    Environment = var.environment

    ManagedBy = "Terraform"

    Project = "Vpc-peering-demo"
  }
}
#################################################
# VPC
#################################################

resource "aws_vpc" "vpc_mumbai" {
  provider = aws.mumbai

  cidr_block           = var.vpc_cidrs[0]
  enable_dns_support   = true
 enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-VPC-Mumbai"
  }
}
resource "aws_vpc" "vpc_singapore" {
  provider = aws.singapore

  cidr_block           = var.vpc_cidrs[1]

 enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-VPC-Singapore"
  }
}
resource "aws_vpc" "vpc_virginia" {
  provider = aws.virginia

  cidr_block           = var.vpc_cidrs[2]

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-VPC-Virginia"
  }
}
##########################################
## Mumbai vpc public subnets
##########################################

resource "aws_subnet" "mumbai_vpc_Public_subnets" {
  provider = aws.mumbai
  count = 1  # I just want 1 subnet if you want you can add more subnets ##
    map_public_ip_on_launch = true

  vpc_id            = aws_vpc.vpc_mumbai.id
  cidr_block        = var.m_public_subnet_cidrs[count.index]
  availability_zone = var.m_public_azs[count.index]

  tags = {
    Name = "${var.environment}-Mumbai-Public-Subnet-${count.index + 1}"
  }
}
##########################################
## mumbai vpc IGW
##########################################

resource "aws_internet_gateway" "mumbai_vpc_igw" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.vpc_mumbai.id

  tags = {
    Name   = "${var.environment}-mumbai_vpc_IGW"
  }
}

####################################
## Mumbai vpc RT
####################################
resource "aws_route_table" "mumbai_vpc_public_rt" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.vpc_mumbai.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mumbai_vpc_igw.id
  }

  tags = {
    Name        = "${var.environment}-mumbai-vpc-Route-Table"
    Environment = "Demo"
  }
}
resource "aws_route" "mumbai_to_singapore" {
  provider               = aws.mumbai
  route_table_id         = aws_route_table.mumbai_vpc_public_rt.id
  destination_cidr_block = var.vpc_cidrs[1]
  transit_gateway_id     = aws_ec2_transit_gateway.mumbai_tgw.id
}

resource "aws_route" "mumbai_to_virginia" {
  provider               = aws.mumbai
  route_table_id         = aws_route_table.mumbai_vpc_public_rt.id
  destination_cidr_block = var.vpc_cidrs[2]
  transit_gateway_id     = aws_ec2_transit_gateway.mumbai_tgw.id
}

#################################################
# MUMBAI VPC PUBLIC ROUTE TABLE ASSOCIATIONS
#################################################

resource "aws_route_table_association" "public_rt" {
  provider = aws.mumbai

  count = 1

  subnet_id = aws_subnet.mumbai_vpc_Public_subnets[count.index].id

  route_table_id = aws_route_table.mumbai_vpc_public_rt.id
}

##########################################
## Singapore vpc public subnets
##########################################

resource "aws_subnet" "singapore_vpc_Public_subnets" {
   provider = aws.singapore
  count = 1  # I just want 1 subnet if you want you can add more subnets ##
    map_public_ip_on_launch = true

  vpc_id            = aws_vpc.vpc_singapore.id
  cidr_block        = var.s_public_subnet_cidrs[count.index]
  availability_zone = var.s_public_azs[count.index]

  tags = {
    Name = "${var.environment}-Singapore-Public-Subnet-${count.index + 1}"
  }
}

##########################################
## singapure vpc IGW
##########################################

resource "aws_internet_gateway" "singapore_vpc_igw" {
  provider = aws.singapore

  vpc_id = aws_vpc.vpc_singapore.id

  tags = {
    Name = "${var.environment}-Singapoe-vpc-IGW"
  }
}

####################################
## Singapore vpc RT
####################################
resource "aws_route_table" "singapore_vpc_public_rt" {
   provider = aws.singapore
  vpc_id   = aws_vpc.vpc_singapore.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.singapore_vpc_igw.id
  }

  tags = {
    Name        = "${var.environment}-singapore-vpc-Route-Table"
    Environment = "Demo"
  }
}

resource "aws_route" "singapore_to_mumbai" {
  provider               = aws.singapore
  route_table_id         = aws_route_table.singapore_vpc_public_rt.id
  destination_cidr_block = var.vpc_cidrs[0]
  transit_gateway_id     = aws_ec2_transit_gateway.singapore_tgw.id
}

resource "aws_route" "singapore_to_virginia" {
  provider               = aws.singapore
  route_table_id         = aws_route_table.singapore_vpc_public_rt.id
  destination_cidr_block = var.vpc_cidrs[2]
  transit_gateway_id     = aws_ec2_transit_gateway.singapore_tgw.id
}
#################################################
# Singapore VPC PUBLIC ROUTE TABLE ASSOCIATIONS
#################################################

resource "aws_route_table_association" "singapore_public_rt_asso" {
   provider = aws.singapore
  count = 1

  subnet_id = aws_subnet.singapore_vpc_Public_subnets[count.index].id

  route_table_id = aws_route_table.singapore_vpc_public_rt.id
}

##########################################
## Virginia vpc public subnets
##########################################

resource "aws_subnet" "virginia_vpc_Public_subnets" {
  provider = aws.virginia
  count = 1  # I just want 1 subnet if you want you can add more subnets ##
    map_public_ip_on_launch = true

  vpc_id            = aws_vpc.vpc_virginia.id
  cidr_block        = var.v_public_subnet_cidrs[count.index]
  availability_zone = var.v_public_azs[count.index]

  tags = {
    Name = "${var.environment}-virginia-Public-Subnet-${count.index + 1}"
  }
}

##########################################
## Virginia vpc IGW
##########################################

resource "aws_internet_gateway" "virginia_vpc_igw" {
   provider = aws.virginia
  vpc_id   = aws_vpc.vpc_virginia.id

  tags = {
    Name   = "${var.environment}-Virginia_vpc-IGW"
  }
}
####################################
## Virginia vpc RT
####################################
resource "aws_route_table" "virginia_vpc_public_rt" {
    provider = aws.virginia
  vpc_id   = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.virginia_vpc_igw.id
  }

  tags = {
    Name        = "${var.environment}-Virginia-vpc-Route-Table"
    Environment = "Demo"
  }
}
resource "aws_route" "virginia_to_mumbai" {
  provider               = aws.virginia
  route_table_id         = aws_route_table.virginia_vpc_public_rt.id
  destination_cidr_block = var.vpc_cidrs[0]
  transit_gateway_id     = aws_ec2_transit_gateway.virginia_tgw.id
}

resource "aws_route" "virginia_to_singapore" {
  provider               = aws.virginia
  route_table_id         = aws_route_table.virginia_vpc_public_rt.id
  destination_cidr_block = var.vpc_cidrs[1]
  transit_gateway_id     = aws_ec2_transit_gateway.virginia_tgw.id
}
#################################################
# Virginia VPC PUBLIC ROUTE TABLE ASSOCIATIONS
#################################################

resource "aws_route_table_association" "virginia_public_rt_asso" {
    provider = aws.virginia
  count = 1

  subnet_id = aws_subnet.virginia_vpc_Public_subnets[count.index].id

  route_table_id = aws_route_table.virginia_vpc_public_rt.id
}

#################################################
# TRANSIT GATEWAYS
#################################################

resource "aws_ec2_transit_gateway" "mumbai_tgw" {
  provider = aws.mumbai

  description                     = "Mumbai Transit Gateway"
  amazon_side_asn                 = 64512
  dns_support                     = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "${var.environment}-Mumbai-TGW"
  }
}

resource "aws_ec2_transit_gateway" "singapore_tgw" {
  provider = aws.singapore

  description                     = "Singapore Transit Gateway"
  amazon_side_asn                 = 64513
  dns_support                     = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "${var.environment}-Singapore-TGW"
  }
}

resource "aws_ec2_transit_gateway" "virginia_tgw" {
  provider = aws.virginia

  description                     = "Virginia Transit Gateway"
  amazon_side_asn                 = 64514
  dns_support                     = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "${var.environment}-Virginia-TGW"
  }
}

#################################################
# VPC ATTACHMENTS
#################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "mumbai_attachment" {
  provider = aws.mumbai

  transit_gateway_id = aws_ec2_transit_gateway.mumbai_tgw.id
  vpc_id             = aws_vpc.vpc_mumbai.id
  subnet_ids         = aws_subnet.mumbai_vpc_Public_subnets[*].id

  tags = {
    Name = "${var.environment}-Mumbai-TGW-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "singapore_attachment" {
  provider = aws.singapore

  transit_gateway_id = aws_ec2_transit_gateway.singapore_tgw.id
  vpc_id             = aws_vpc.vpc_singapore.id
  subnet_ids         = aws_subnet.singapore_vpc_Public_subnets[*].id

  tags = {
    Name = "${var.environment}-Singapore-TGW-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "virginia_attachment" {
  provider = aws.virginia

  transit_gateway_id = aws_ec2_transit_gateway.virginia_tgw.id
  vpc_id             = aws_vpc.vpc_virginia.id
  subnet_ids         = aws_subnet.virginia_vpc_Public_subnets[*].id

  tags = {
    Name = "${var.environment}-Virginia-TGW-Attachment"
  }
}


#################################################
# MUMBAI <--> SINGAPORE
#################################################

resource "aws_ec2_transit_gateway_peering_attachment" "mumbai_singapore" {
  provider = aws.mumbai

  transit_gateway_id      = aws_ec2_transit_gateway.mumbai_tgw.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.singapore_tgw.id
  peer_region             = var.aws_region_2

  tags = {
    Name = "${var.environment}-Mumbai-Singapore-Peering"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "mumbai_singapore" {
  provider = aws.singapore

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.mumbai_singapore.id

  tags = {
    Name = "${var.environment}-Mumbai-Singapore-Accepter"
  }
}

#################################################
# SINGAPORE <--> VIRGINIA
#################################################

resource "aws_ec2_transit_gateway_peering_attachment" "singapore_virginia" {
  provider = aws.singapore

  transit_gateway_id      = aws_ec2_transit_gateway.singapore_tgw.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.virginia_tgw.id
  peer_region             = var.aws_region_3

  tags = {
    Name = "${var.environment}-Singapore-Virginia-Peering"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "singapore_virginia" {
  provider = aws.virginia

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.singapore_virginia.id

  tags = {
    Name = "${var.environment}-Singapore-Virginia-Accepter"
  }
}

#################################################
# VIRGINIA <--> MUMBAI
#################################################

resource "aws_ec2_transit_gateway_peering_attachment" "virginia_mumbai" {
  provider = aws.virginia

  transit_gateway_id      = aws_ec2_transit_gateway.virginia_tgw.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.mumbai_tgw.id
  peer_region             = var.aws_region_1

  tags = {
    Name = "${var.environment}-Virginia-Mumbai-Peering"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "virginia_mumbai" {
  provider = aws.mumbai

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.virginia_mumbai.id

  tags = {
    Name = "${var.environment}-Virginia-Mumbai-Accepter"
  }
}


#################################################
# MUMBAI TGW ROUTES
#################################################

resource "aws_ec2_transit_gateway_route" "mumbai_to_singapore" {
  provider = aws.mumbai

  transit_gateway_route_table_id = aws_ec2_transit_gateway.mumbai_tgw.association_default_route_table_id
  destination_cidr_block         = var.vpc_cidrs[1]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.mumbai_singapore.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.mumbai_singapore]
  
}

resource "aws_ec2_transit_gateway_route" "mumbai_to_virginia" {
  provider = aws.mumbai

  transit_gateway_route_table_id = aws_ec2_transit_gateway.mumbai_tgw.association_default_route_table_id
  destination_cidr_block         = var.vpc_cidrs[2]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.virginia_mumbai.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.virginia_mumbai]
  
}

#################################################
# SINGAPORE TGW ROUTES
#################################################

resource "aws_ec2_transit_gateway_route" "singapore_to_mumbai" {
  provider = aws.singapore

  transit_gateway_route_table_id = aws_ec2_transit_gateway.singapore_tgw.association_default_route_table_id
  destination_cidr_block         = var.vpc_cidrs[0]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.mumbai_singapore.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.mumbai_singapore]
  
}

resource "aws_ec2_transit_gateway_route" "singapore_to_virginia" {
  provider = aws.singapore

  transit_gateway_route_table_id = aws_ec2_transit_gateway.singapore_tgw.association_default_route_table_id
  destination_cidr_block         = var.vpc_cidrs[2]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.singapore_virginia.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.singapore_virginia]
  
}

#################################################
# VIRGINIA TGW ROUTES
#################################################

resource "aws_ec2_transit_gateway_route" "virginia_to_mumbai" {
  provider = aws.virginia

  transit_gateway_route_table_id = aws_ec2_transit_gateway.virginia_tgw.association_default_route_table_id
  destination_cidr_block         = var.vpc_cidrs[0]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.virginia_mumbai.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.virginia_mumbai]
  
}

resource "aws_ec2_transit_gateway_route" "virginia_to_singapore" {
  provider = aws.virginia

  transit_gateway_route_table_id = aws_ec2_transit_gateway.virginia_tgw.association_default_route_table_id
  destination_cidr_block         = var.vpc_cidrs[1]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.singapore_virginia.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.singapore_virginia]
  
}

###################################################
## MUMBAI VPC SG
###################################################
resource "aws_security_group" "mumbai_vpc_sg" {
  provider = aws.mumbai
  name        = "mumbai_vpc_sg"
  description = "Security group for VPC Peering 1 instance"
  vpc_id      = aws_vpc.vpc_mumbai.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.31.0.0/16","192.168.0.0/16"]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Mumbai_Vpc-SG"
    Environment = "Demo"
  }
}

###################################################
## SINGAPORE VPC SG
###################################################
resource "aws_security_group" "singapore_vpc_sg" {
  provider = aws.singapore
  name        = "singapore_vpc_sg"
  description = "Security group for VPC Peering 2 instance"
  vpc_id      = aws_vpc.vpc_singapore.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16","192.168.0.0/16"]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Singapore_Vpc-SG"
    Environment = "Demo"
  }
}

###################################################
## VIRGINIA VPC SG
###################################################
resource "aws_security_group" "virginia_vpc_sg" {
  provider = aws.virginia
  name        = "virginia_vpc_sg"
  description = "Security group for VPC Peering 3 instance"
  vpc_id      = aws_vpc.vpc_virginia.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16","172.31.0.0/16"]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Virginia_Vpc-SG"
    Environment = "Demo"
  }
}

#############################################
# Mumbai vpc Instance
#############################################

resource "aws_instance" "mumbai_vpc_instance" {
    provider = aws.mumbai
   count = 1
  ami                    = data.aws_ami.mumbai_vpc_instance_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.mumbai_vpc_Public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.mumbai_vpc_sg.id]
  key_name               = var.mumbai_vpc_instance_key_name

  user_data = local.mumbai_vpc_instance_user_data

  tags = {
    Name        = "Mumbai_vpc-Instance"
    Environment = "Demo"
    Region      = var.mumbai_vpc_region
  }

  depends_on = [
  aws_vpc_peering_connection_accepter.singapore_vpc_accepter
]
}
#############################################
# Singapore vpc Instance
#############################################

resource "aws_instance" "singapore_vpc_instance" {
  provider = aws.singapore
   count = 1
  ami                    = data.aws_ami.singapore_vpc_instance_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.singapore_vpc_Public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.singapore_vpc_sg.id]
  key_name               = var.singapore_vpc_instance_key_name

  user_data = local.singapore_vpc_instance_user_data

  tags = {
    Name        = "Singapore_vpc-Instance"
    Environment = "Demo"
    Region      = var.singapore_vpc_region
  }

 depends_on = [
  aws_vpc_peering_connection_accepter.virginia_vpc_accepter
]
}
#############################################
# Virginia vpc Instance
#############################################

resource "aws_instance" "virginia_vpc_instance" {
  provider = aws.virginia
  count = 1

  ami                    = data.aws_ami.virginia_vpc_instance_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.virginia_vpc_Public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.virginia_vpc_sg.id]
  key_name               = var.virginia_vpc_instance_key_name

  user_data = local.virginia_vpc_instance_user_data

  tags = {
    Name        = "Virginia_vpc-Instance"
    Environment = "Demo"
    Region      = var.virginia_vpc_region
  }

 depends_on = [
  aws_vpc_peering_connection_accepter.mumbai_vpc_accepter
]
}