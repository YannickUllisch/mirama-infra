module "messaging" {
  source = "../../../modules/messaging"

  account_id           = data.aws_caller_identity.current.account_id
  environment          = "prod"
  vercel_iam_user_name = "Vercel"
  # private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
}