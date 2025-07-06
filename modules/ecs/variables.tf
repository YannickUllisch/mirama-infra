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

variable "ecs_instance_profile_arn" {
  description = "ARN of the ECS instance profile to use for the ECS tasks"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role to use for the ECS tasks"
  type        = string
}

variable "ecs_exec_role_arn" {
  description = "ARN of the ECS exec role to use for the ECS tasks"
  type        = string
}