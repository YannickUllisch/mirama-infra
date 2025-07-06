module "ecs" {
  source = "../../../modules/ecs"

  environment       = "prod"
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_id  = data.terraform_remote_state.network.outputs.public_subnet_id
  ecr_repo_url      = data.terraform_remote_state.ecr.outputs.repository_url
  ecs_instance_profile_arn = data.terraform_remote_state.iam.outputs.ecs_instance_profile_arn
  ecs_exec_role_arn = data.terraform_remote_state.iam.outputs.ecs_exec_role_arn
  ecs_task_role_arn = data.terraform_remote_state.iam.outputs.ecs_task_role_arn
}