output "secret_arns" {
  description = "The ARN of the secrets created in AWS Secrets Manager by key"
  value = {
    for secret_name in var.secret_names : secret_name => aws_secretsmanager_secret.main[secret_name].arn
  }
}