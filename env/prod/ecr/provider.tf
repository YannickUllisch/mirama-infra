terraform {
  required_version = ">= 1.7.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }

  backend "s3" {
    bucket  = "mirama-prod-infrastructure"
    key     = "state/ecr/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      environment      = "production"
      application-name = "mirama"
    }
  }
}