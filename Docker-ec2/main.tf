#################################################
# UBUNTU AMI
#################################################

data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

#################################################
# EC2 UBUNTU DOCKER SERVER
#################################################

resource "aws_instance" "docker_server" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public.id

  key_name = "docker-key"

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  user_data = <<-EOF
#!/bin/bash

set -eux

#################################################
# UPDATE SYSTEM
#################################################

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

#################################################
# INSTALL DOCKER, GIT AND PYTHON
#################################################

apt-get install -y \
  docker.io \
  git \
  python3 \
  python3-pip

#################################################
# ENABLE AND START DOCKER
#################################################

systemctl enable docker
systemctl start docker

#################################################
# ADD UBUNTU DEFAULT USER TO DOCKER GROUP
#################################################

sudo su
sudo usermod -aG docker ubuntu
sudo su ubuntu


#################################################
# VERIFY INSTALLATION
#################################################

docker --version
git --version
python3 --version
pip3 --version

# mkdir -p /home/ubuntu/app-stack

EOF

  tags = {
    Name = "ubuntu-docker-server"
  }
}