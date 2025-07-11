variable "environment" {
  description = "The environment for which the RDS instance is being created (e.g., dev, staging, prod)."
  type        = string
}

variable "vpc_id" {
  description = "VPC generated from the network module"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs provisioned in the network module for RDS"
  type        = list(string)
}