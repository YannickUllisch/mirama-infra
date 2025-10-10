output "sns-arn" {
  description = "ARN of the SNS topic for notifications"
  value       = aws_sns_topic.main.arn
}