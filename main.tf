provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "kaiocm-terraform-ec2" {
  ami = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  subnet_id = "subnet-c2e2cd9a" # PRIVATE-AZ-2C

  vpc_security_group_ids = [aws_security_group.kaioc-terraform-sg.id]
  iam_instance_profile = "PingInstanceRole" # has some safety policies from hp
  tags = {
    Name = "kaiocm-terraform-ec2"
  }
}

# Security Group
resource "aws_security_group" "kaioc-terraform-sg" {
  name = "kaioc-terraform-sg"
  vpc_id = "vpc-faf77d9d"
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"] # hp subnets + hp vpn
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"] # inside out
  }
  tags = {
    Name = "kaioc-terraform-sg"
  }
}