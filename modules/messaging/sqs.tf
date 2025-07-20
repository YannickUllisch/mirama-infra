resource "aws_sqs_queue" "notification_sqs" {
  name = "notification-sqs"
  fifo_queue = true
}

resource "aws_sns_topic_subscription" "notification_sqs_target" {
  topic_arn = aws_sns_topic.notification_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.notification_sqs.arn
}

resource "aws_sqs_queue_policy" "results_updates_queue_policy" {
    queue_url = "${aws_sqs_queue.notification_sqs.id}"

    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.notification_sqs.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.notification_sns.arn}"
        }
      }
    }
  ]
}
POLICY
}