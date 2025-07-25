module "cognito" {
  source = "../../../modules/cognito"

  environment          = "prod"
  domain_url           = "mirama.yannickullisch.com"
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
}