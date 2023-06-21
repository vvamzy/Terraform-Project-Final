locals {
  # city = "Hyderabad"
  # team = "DevOps"
  # onsite = true
  # year = 2023
  filename = "hello7.txt"
}

# data "aws_ami" "myami" {
#   most_recent      = true
#   name_regex       = "Lunar"

#   filter {
#     name   = "name"
#     values = ["ami-*"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "Define cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share."
}

resource "local_file" "hi" {
  filename = "hi.txt"
  content  = "Define cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share."
}

# resource "random_pet" "my-pet" {
#   prefix = var.prefix[0]
#   separator = "*"
#   length = 5
# }

# resource "local_file" "experimenting-variables" {
#   filename = var.file_name
#   content = var.message
# }

resource "local_file" "map-variable" {
  filename = var.file_name
  content  = var.content["India"]
}

resource "local_file" "local-variable" {
  filename        = local.filename
  content         = "${terraform.workspace}"
  file_permission = 600
}

module "subnet" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = "172.0.0.0/16"
  networks = [
    {
      name     = "module_A"
      new_bits = 4
    },
    {
      name     = "module_B"
      new_bits = 4
    },
  ]
}

output "subnets" {
  value = module.subnet.network_cidr_blocks
}

output "hello7-id" {
  value = local_file.local-variable.directory_permission
}