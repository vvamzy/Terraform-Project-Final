module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = "192.168.0.0/16"
  networks = [
    {
      name     = "sub1"
      new_bits = 8
    },
    {
      name     = "sub2"
      new_bits = 4
    },
  ]
}

terraform {
  required_version = "~>1.4.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.65.0"
    }
  }
}

resource "aws_vpc" "vpc-tf-1" {
  cidr_block       = module.subnet_addrs.base_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "created-terraform"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.vpc-tf-1.id
  cidr_block = module.subnet_addrs.network_cidr_blocks.sub1

  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.vpc-tf-1.id
  cidr_block = module.subnet_addrs.network_cidr_blocks.sub2

  tags = {
    Name = "public-1"
  }
}

output "sub_addrs" {
  value = module.subnet_addrs.network_cidr_blocks
}

output "arn" {
  value = aws_subnet.private-1.arn
}

output "az" {
  value = aws_subnet.public-1.availability_zone
}

output "rt" {
  value = aws_vpc.vpc-tf-1.default_route_table_id
  
}