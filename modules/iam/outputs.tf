output "ecs_instance_profile_arn" {
  description = "Name of the ECS instance role"
  value       = aws_iam_instance_profile.ecs_instance_profile.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_exec_role_arn" {
  description = "ARN of the ECS exec role"
  value       = aws_iam_role.ecs_exec_role.arn
}