output "repository_url" {
    description = "ECR repository URL for the ECS task"
    value       = aws_ecr_repository.ecr.repository_url
}