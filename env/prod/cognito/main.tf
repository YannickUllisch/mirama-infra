module "cognito" {
  source = "../../../modules/cognito"

  environment = "prod"
  domain_url  = "mirama.yannickullisch.com"
}