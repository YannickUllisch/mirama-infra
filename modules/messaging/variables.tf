variable "private_subnet_ids" {
  description = "IDs of two the private subnets in the VPC"
  type        = list(string)
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}


variable "vercel_iam_user_name" {
  description = "IAM user name for Vercel to allow publishing to SNS"
  type        = string
}

variable "domain_name" {
  description = "Domain name of Mirama service set up in route 53"
  type        = string
}

variable "aws_region" {
  description = "Domain name of Mirama service set up in route 53"
  type        = string
  default     = "eu-west-1"
}