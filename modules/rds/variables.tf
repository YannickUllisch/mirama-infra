variable "environment" {
  description = "The environment for which the RDS instance is being created (e.g., dev, staging, prod)."
  type = string
}

variable "vpc_id" {
  description = "VPC generated from the network module"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "rds_subnet_id" {
  description = "Private Subnet for RDS instances"
  type = string
}