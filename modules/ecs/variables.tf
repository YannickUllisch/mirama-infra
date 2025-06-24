variable "vpc_id" {
  description = "VPC generated from the network module"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of Public subnet to deploy ECS tasks"
  type        = string
}

variable "ecr_repo_url" {
  description = "ECR repository URL for the ECS task"
  type        = string
}

variable "environment" {
  description = "The environment for which the repository is being created (e.g., dev, staging, prod)."
  type        = string
}