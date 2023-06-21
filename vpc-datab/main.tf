terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

locals {
  subnet1 = "10.0.1.0/24"
  subnet2 = "10.0.2.0/25"
}

variable "vpc_id" {
    default = "vpc-050a7a99aa20d1edc"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "ap-south-1a"
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
}

resource "aws_subnet" "subnet-1" {
    vpc_id = data.aws_vpc.selected.id
    cidr_block = local.subnet1
}

resource "aws_subnet" "subnet-2" {
    vpc_id = data.aws_vpc.selected.id
    cidr_block = local.subnet2
}

output "subnet1-id" {
    value = aws_subnet.subnet-1.id
}

output "subnet2-id" {
    value = aws_subnet.subnet-2.id
}