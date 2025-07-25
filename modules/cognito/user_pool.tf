resource "aws_cognito_user_pool" "pool" {
  // General configuration
  name                     = "mirama-${var.environment}-user-pool"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  password_policy {
    minimum_length    = 6
    require_uppercase = true
    require_symbols   = true
  }

  // Don't allow public sign ups, we handle sign up logic in our app manually through the AWS API
  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  // MFA Setup
  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration {
    enabled = true
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true
    string_attribute_constraints {
      min_length = 5
      max_length = 2048
    }
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "mirama-${var.environment}-client"

  user_pool_id                         = aws_cognito_user_pool.pool.id
  generate_secret                      = false
  refresh_token_validity               = 90
  prevent_user_existence_errors        = "ENABLED"
  allowed_oauth_flows_user_pool_client = true

  callback_urls = [
    "https://${var.domain_url}/api/auth/callback/cognito",
    "http://localhost:3000/api/auth/callback/cognito"
  ]

  logout_urls = [
    "https://${var.domain_url}/api/auth/signout",
    "http://localhost:3000/api/auth/signout"
  ]

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
  ]


  allowed_oauth_flows          = ["code"]
  allowed_oauth_scopes         = ["openid", "email", "profile"]
  supported_identity_providers = ["COGNITO", "Google"]
  depends_on                   = [aws_cognito_identity_provider.google]

}
resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = "mirama-prod"
  user_pool_id = aws_cognito_user_pool.pool.id
}