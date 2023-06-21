terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

locals {
   team = "devops"
   OS = "Linux"
   terraform = true
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_vpc" "vpc1" {
  cidr_block       = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
  instance_tenancy = "default"
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name = "main"
    region = var.region
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "security_group_tf_1"
  description = "Allow TLS inbound traffic, created with tf"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "kst-test-bucket-devops-${random_password.password.id}"

  tags = {
    Name        = "tf-1-s3"
    Environment = "Dev"
    region = var.region
    Team = local.team
    Team2 = var.team
    OS = local.OS
    terraform = local.terraform

  }
}

resource "random_password" "password" {
  length           = 4
}