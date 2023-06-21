provider "aws" {}

resource "aws_instance" "import-instance" {
  instance_type = "t2.micro"
  ami           = "ami-0f5ee92e2d63afc18"
  key_name      = "mumbai"
  tags = {
    "Name" = "terraform"
  }
}