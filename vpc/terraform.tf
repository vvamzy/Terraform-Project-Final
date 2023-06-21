terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "KST-DevOps"
    workspaces {
      name = "test-deploy"
    }
  }
  required_version = "~>1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.3.0"
    }
  }
}