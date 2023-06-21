variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}


resource "aws_instance" "web_server" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  tags = {
    Name = "Terraform"
  }
}

output "public-ip" {
  value = aws_instance.web_server.public_ip
  
}