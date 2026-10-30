################################################
# SECURITY GROUP
#################################################

resource "aws_security_group" "ec2_sg" {

  name = "docker-demo-sg"

  vpc_id = aws_vpc.main.id

  #################################################
  # SSH
  #################################################

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  #################################################
  # HTTP
  #################################################

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
  description = "Allow port 8080"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


  #################################################
  # OUTBOUND
  #################################################

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}