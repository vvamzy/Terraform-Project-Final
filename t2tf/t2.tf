terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

resource "aws_vpc" "vpc-tf-1" {
  cidr_block       = "172.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "created-terraform"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.vpc-tf-1.id
  cidr_block = "172.0.1.0/24"

  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.vpc-tf-1.id
  cidr_block = "172.0.2.0/24"

  tags = {
    Name = "public-1"
  }
}

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-1.id
  tags = {
    Name = "Ubuntu EC2 Server"
  }
}