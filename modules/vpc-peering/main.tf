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
#################################################
# Virginia VPC PUBLIC ROUTE TABLE ASSOCIATIONS
#################################################

resource "aws_route_table_association" "virginia_public_rt_asso" {
    provider = aws.virginia
  count = 1

  subnet_id = aws_subnet.virginia_vpc_Public_subnets[count.index].id

  route_table_id = aws_route_table.virginia_vpc_public_rt.id
}
############################################
# VPC 1 <-> VPC 2
############################################

# VPC Peering Connection (Requester side - Mumbai VPC)
resource "aws_vpc_peering_connection" "mumbai_to_singapore" {
  provider = aws.mumbai
  vpc_id      = aws_vpc.vpc_mumbai.id
  peer_vpc_id = aws_vpc.vpc_singapore.id
  peer_region = var.aws_region_2
  auto_accept = false

  tags = {
    Name        = "mumbai-to-singapore-peering"
    Environment = "Demo"
    Side        = "Requester"
  }
}
resource "aws_vpc_peering_connection_accepter" "singapore_vpc_accepter" {
  provider = aws.singapore
  vpc_peering_connection_id = aws_vpc_peering_connection.mumbai_to_singapore.id
  auto_accept               = true

  tags = {
    Name        = "Singapore_vpc-Peering-Accepter"
    Environment = "Demo"
    Side        = "Accepter"
  }
}
# VPC 1 -> VPC 2  # Rout table modification #
resource "aws_route" "Mumbai_vpc_to_singapore_vpc" {
  provider = aws.mumbai
  route_table_id            = aws_route_table.mumbai_vpc_public_rt.id
  destination_cidr_block    = var.vpc_cidrs[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.mumbai_to_singapore.id

  depends_on = [aws_vpc_peering_connection_accepter.singapore_vpc_accepter]
}
resource "aws_route" "Singapore_vpc_to_Mumbai_vpc" {
  provider = aws.singapore
  route_table_id            = aws_route_table.singapore_vpc_public_rt.id
  destination_cidr_block    = var.vpc_cidrs[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.mumbai_to_singapore.id

  depends_on = [
    aws_vpc_peering_connection_accepter.singapore_vpc_accepter
  ]
}
#############################################
## Vpc 2 <---> Vpc 3
#############################################

# VPC Peering Connection (Requester side - Singapore VPC)
resource "aws_vpc_peering_connection" "singapore_to_virginia" {
   provider = aws.singapore
  vpc_id      = aws_vpc.vpc_singapore.id
  peer_vpc_id = aws_vpc.vpc_virginia.id
  peer_region = var.aws_region_3
  auto_accept = false

  tags = {
    Name        = "Singapore-to-virginia-peering"
    Environment = "Demo"
    Side        = "Requester"
  }
}
resource "aws_vpc_peering_connection_accepter" "virginia_vpc_accepter" {
    provider = aws.virginia
  vpc_peering_connection_id = aws_vpc_peering_connection.singapore_to_virginia.id
  auto_accept               = true

  tags = {
    Name        = "Virginia_vpc-Peering-Accepter"
    Environment = "Demo"
    Side        = "Accepter"
  }
}
# VPC 2 -> VPC 3  # Rout table modification #
resource "aws_route" "singapore_vpc_to_virginia_vpc" {
  provider = aws.singapore
  route_table_id            = aws_route_table.singapore_vpc_public_rt.id
  destination_cidr_block    = var.vpc_cidrs[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.singapore_to_virginia.id

  depends_on = [aws_vpc_peering_connection_accepter.virginia_vpc_accepter]
}
# VPC 3 -> VPC 2  # Rout table modification #
resource "aws_route" "virginia_vpc_to_singapore_vpc" {
  provider = aws.virginia
  route_table_id            = aws_route_table.virginia_vpc_public_rt.id
  destination_cidr_block    = var.vpc_cidrs[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.singapore_to_virginia.id

  depends_on = [
    aws_vpc_peering_connection_accepter.virginia_vpc_accepter]

}
#############################################
## Vpc 2 <---> Vpc 3
#############################################

# VPC Peering Connection (Requester side - Virginia VPC)
resource "aws_vpc_peering_connection" "virginia_to_mumbai" {
   provider = aws.virginia
  vpc_id      = aws_vpc.vpc_virginia.id
  peer_vpc_id = aws_vpc.vpc_mumbai.id
  peer_region = var.aws_region_1
  auto_accept = false

  tags = {
    Name        = "Virginia-to-Mumbai-peering"
    Environment = "Demo"
    Side        = "Requester"
  }
}
resource "aws_vpc_peering_connection_accepter" "mumbai_vpc_accepter" {
    provider = aws.mumbai
  vpc_peering_connection_id = aws_vpc_peering_connection.virginia_to_mumbai.id
  auto_accept               = true

  tags = {
    Name        = "Mumbai_vpc-Peering-Accepter"
    Environment = "Demo"
    Side        = "Accepter"
  }
}
# VPC 3 -> VPC 1  # Rout table modification #
resource "aws_route" "virginia_vpc_to_mumbai_vpc" {
  provider = aws.virginia
  route_table_id            = aws_route_table.virginia_vpc_public_rt.id
  destination_cidr_block    = var.vpc_cidrs[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.virginia_to_mumbai.id

  depends_on = [aws_vpc_peering_connection_accepter.mumbai_vpc_accepter]
}
# VPC 3 -> VPC 1  # Rout table modification #
resource "aws_route" "mumbai_vpc_to_virginia_vpc" {
  provider = aws.mumbai
  route_table_id            = aws_route_table.mumbai_vpc_public_rt.id
  destination_cidr_block    = var.vpc_cidrs[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.virginia_to_mumbai.id

  depends_on = [aws_vpc_peering_connection_accepter.mumbai_vpc_accepter]
}

###################################################
## Mumbai Vpc Sg
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
## Singapore Vpc Sg
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
## Virginia Vpc Sg
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
# Mumbai vpc 1 Instance
#############################################

resource "aws_instance" "mumbai_vpc_instance" {
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

  depends_on = [aws_vpc_peering_connection_accepter.singapore_vpc_accepter]
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

  depends_on = [aws_vpc_peering_connection_accepter.virginia_vpc_accepter]
}
#############################################
# Singapore vpc Instance
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
  depends_on = [aws_vpc_peering_connection_accepter.mumbai_vpc_accepter]
}
