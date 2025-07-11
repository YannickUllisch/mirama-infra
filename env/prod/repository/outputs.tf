output "repository_url" {
  description = "ECR repository URL for the ECS task"
  value       = module.ecr.repository_url
}