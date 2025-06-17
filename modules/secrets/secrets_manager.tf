resource "aws_secretsmanager_secret" "main" {
  for_each = toset(var.secret_names)

  name = each.value
}