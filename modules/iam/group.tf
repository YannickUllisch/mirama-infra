resource "aws_iam_group" "developers" {
  name = "mirama-developers"
  path = "/users/"
}

resource "aws_iam_policy" "sns_publish" {
  name        = "mirama-sns-policy"
  description = "Allow publishing to SNS topics"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowSnsPublish"
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "cognito_admin" {
  name        = "mirama-cognito-admin"
  description = "Allow Cognito admin user management actions."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCognitoAdminUserManagement"
        Effect = "Allow"
        Action = [
          "cognito-idp:AdminCreateUser",
          "cognito-idp:AdminDeleteUser",
          "cognito-idp:AdminResetUserPassword",
          "cognito-idp:ResendConfirmationCode",
          "cognito-idp:ConfirmSignUp",
          "cognito-idp:AdminSetUserPassword"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "developers_sns" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.sns_publish.arn
}

resource "aws_iam_group_policy_attachment" "developers_cognito_admin" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.cognito_admin.arn
}