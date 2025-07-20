resource "aws_lambda_event_source_mapping" "notif-lambda-trigger" {
  event_source_arn = aws_sqs_queue.notification_sqs.arn
  function_name    = "notification-lambda"
  batch_size       = 10
}