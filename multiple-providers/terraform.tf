terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.64.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    http = {
      source = "hashicorp/http"
      version = "3.3.0"
    }
  }
}