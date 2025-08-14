module "ecs" {
  source = "../../../modules/ecs"

  environment              = "prod"
  vpc_id                   = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids        = data.terraform_remote_state.network.outputs.public_subnet_ids
  ecr_repo_url             = data.terraform_remote_state.ecr.outputs.repository_url
  ecs_instance_profile_arn = data.terraform_remote_state.iam.outputs.ecs_instance_profile_arn
  ecs_exec_role_arn        = data.terraform_remote_state.iam.outputs.ecs_exec_role_arn
  ecs_task_role_arn        = data.terraform_remote_state.iam.outputs.ecs_task_role_arn
  sub_domain               = "mirama-ecs"
  domain_name              = "yannickullisch.com"
  POSTGRES_PRISMA_URL      = var.POSTGRES_PRISMA_URL
  POSTGRES_URL_NON_POOLING = var.POSTGRES_URL_NON_POOLING
  REDIS_URL                = var.REDIS_URL
  NEXTAUTH_SECRET          = var.NEXTAUTH_SECRET
  RESEND_API_KEY           = var.RESEND_API_KEY
  AWS_SECRET_ACCESS_KEY    = var.AWS_SECRET_ACCESS_KEY
  AWS_ACCESS_KEY_ID        = var.AWS_ACCESS_KEY_ID
  NOTIFICATION_TOPIC_ARN   = var.NOTIFICATION_TOPIC_ARN
  COGNITO_DOMAIN_URL       = var.COGNITO_DOMAIN_URL
  COGNITO_CLIENT_ID        = var.COGNITO_CLIENT_ID
  COGNITO_ISSUER           = var.COGNITO_ISSUER
  COGNITO_USER_POOL_ID     = var.COGNITO_USER_POOL_ID
}