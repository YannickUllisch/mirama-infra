resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/mirama-${var.environment}"
  retention_in_days = 14
}