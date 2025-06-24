module "ecr" {
  source = "../../../modules/repository"
  environment = "prod"
}
