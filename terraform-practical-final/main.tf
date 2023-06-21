provider "aws" {}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "myvpc"
  }
}

resource "aws_subnet" "my-subnet-pu" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_subnet" "my-subnet-pr" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    "Name" = "private-subnet"
  }
}

resource "aws_route_table" "my-route-table-public" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gateway.id
  }
  tags = {
    "Name" = "rt-public"
  }
}

resource "aws_route_table_association" "public-rt-associate" {
  subnet_id      = aws_subnet.my-subnet-pu.id
  route_table_id = aws_route_table.my-route-table-public.id
}

resource "aws_internet_gateway" "my-gateway" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-gateway"
  }
}

resource "aws_instance" "my-instance" {
  ami             = var.ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my-subnet-pu.id
  key_name        = aws_key_pair.my-key.key_name
  vpc_security_group_ids = [ aws_security_group.my-sg.id ]
  associate_public_ip_address = true
  tags = {
    "Name" = "Test-Server"
  }

  provisioner "remote-exec" {
    connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("testing-key")
    host        = self.public_ip
  }
    inline = [
      "sudo apt install -y apache2",
      "sudo touch ~/created_terraform.txt",
      "sudo systemctl start apache2",
      "sudo apt install -y tree",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ips.txt"
  }

#   provisioner "file" {
#     source      = "variables.tf"
#     destination = "/tmp/variables.tf"
#   }
}

resource "aws_key_pair" "my-key" {
  key_name   = "testing-key"
  public_key = local_file.pub-file.content
}

resource "tls_private_key" "my-keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pub-file" {
  content  = tls_private_key.my-keypair.public_key_openssh
  filename = "testing-key.pub"
}

resource "local_file" "pem-file" {
  content  = tls_private_key.my-keypair.private_key_pem
  filename = "testing-key"

}

resource "aws_security_group" "my-sg" {
  name        = "Security group to allow 80,443,8080"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description = "allow 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom-sg"
  }
}

# resource "aws_cloudwatch_metric_alarm" "foobar" {
#   alarm_name                = "terraform-test-foobar5"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = 2
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = 120
#   statistic                 = "Average"
#   threshold                 = 80
#   alarm_description         = "This metric monitors ec2 cpu utilization"
#   insufficient_data_actions = []
# }

resource "aws_ebs_volume" "my-ebs" {
  availability_zone = "ap-south-1a"
  size              = 1

  tags = {
    Name = "ebs-storage-1"
  }
}

resource "aws_volume_attachment" "my-ebs-associate" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.my-ebs.id
  instance_id = aws_instance.my-instance.id
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = "kst-terraform-practice-final"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# resource "aws_s3_bucket_acl" "my-s3-bucket" {
#   bucket = aws_s3_bucket.my-bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.my-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_db_instance" "my-rds" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  tags = {
    "Name" = "My-DB"
  }
}