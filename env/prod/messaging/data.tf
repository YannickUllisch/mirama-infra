data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "mirama-infra"
    region = "eu-west-1"
    key    = "prod/network/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}