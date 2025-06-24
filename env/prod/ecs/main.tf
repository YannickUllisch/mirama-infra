module "ecs" {
  source = "../../../modules/ecs"

  environment       = "prod"
  vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_id  = data.terraform_remote_state.network.outputs.public_subnet_id
  ecr_repo_url      = data.terraform_remote_state.ecr.outputs.repository_url
}