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

module "instance" {
    source = "./instance"

    ami = "ami-057752b3f1d6c4d6c"
    instance_type = "t2.micro"
    subnet_id     = "subnet-03adf1d50977cc63c"
}

