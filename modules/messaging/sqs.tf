resource "aws_sqs_queue" "notification_sqs" {
  name = "mirama-notification-queue-${var.environment}"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_queue.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "deadletter_queue" {
  name = "mirama-deadletter-queue-${var.environment}"
}

# Allows the notification queue to send messages to the DQL
resource "aws_sqs_queue_redrive_allow_policy" "terraform_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.deadletter_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.notification_sqs.arn]
  })
}

resource "aws_sns_topic_subscription" "notification_sqs_target" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.notification_sqs.arn
}

# Allow only SNS topic to send messages to the SQS queue
resource "aws_sqs_queue_policy" "notification_sqs_policy" {
  queue_url = aws_sqs_queue.notification_sqs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "SQS:SendMessage",
        Resource = aws_sqs_queue.notification_sqs.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.main.arn
          }
        }
      }
    ]
  })
}