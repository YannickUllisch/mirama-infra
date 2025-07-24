resource "aws_sns_topic" "notification_sns" {
  name = "mirama-notification-sns-${var.environment}"
}

# Allowing Vercel IAM user (identity taken by app hosted on Vercel) to publish messages to the SNS topic 
resource "aws_sns_topic_policy" "notification_sns_policy" {
  arn = aws_sns_topic.notification_sns.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:user/${var.vercel_iam_user_name}"
        },
        Action   = "SNS:Publish",
        Resource = aws_sns_topic.notification_sns.arn
      }
    ]
  })
}