variable "region" {
    description = "indicates region to deploy the infra"
    # default = "ap-south-1"
    type = string
}

variable "team" {
    # default = "DevOps-Avengers"
    type = string
}

variable "vpc_id" {}
