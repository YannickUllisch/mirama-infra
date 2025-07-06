output "ecs_instance_profile_arn" {
  value = module.iam.ecs_instance_profile_arn
}

output "ecs_task_role_arn" {
  value = module.iam.ecs_task_role_arn
}

output "ecs_exec_role_arn" {
  value = module.iam.ecs_exec_role_arn
}