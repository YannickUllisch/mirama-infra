terraform {
  required_version = ">= 1.4.6"

  backend "s3" {
    bucket = "et-prod-infrastructure"
    key    = "bricklens/secrets/terraform.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32"

    }
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
