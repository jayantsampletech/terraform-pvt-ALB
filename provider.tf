provider "aws" {
  region = "ap-south-1"
}
terraform {
  backend "s3" {
    bucket  = "my-terraform-state-jayant"
    key     = "statestorefiles"
    region  = "ap-south-1"
    encrypt = true
  }
}

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}