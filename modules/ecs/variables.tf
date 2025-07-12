variable "vpc_id" {
  description = "VPC generated from the network module"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of two the public subnets in the VPC"
  type        = list(string)
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

variable "sub_domain" {
  description = "Subdomain name for the ECS service, with root being yannickullisch.com"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the ECS service, e.g., yannickullisch.com"
  type        = string
}

variable "container_name" {
  description = "Name of the container in the ECS task definition"
  type        = string
  default     = "mirama-app"
}

variable "container_port" {
  description = "Exposed port of the container in the ECS task definition"
  type        = number
  default     = 3000
}
