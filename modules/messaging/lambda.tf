// Deny all ingress by default due to SQS setup
# resource "aws_security_group" "lambda_sg" {
#   name        = "mirama-${var.environment}-lambda-sg"
#   description = "Security group for Lambda in VPC"
#   vpc_id      = var.vpc_id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_lambda_function" "notification_lambda" {
  function_name    = "mirama-${var.environment}-notif-lambda"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "go1.x"
  handler          = "main"
  filename         = data.archive_file.go_lambda_zip.output_path
  source_code_hash = data.archive_file.go_lambda_zip.output_base64sha256
  timeout          = 10
  publish          = true

  // Lambda not in VPC for testing purposes to be able to access Neon DB
  #   vpc_config {
  #     subnet_ids = var.private_subnet_ids
  #     security_group_ids = [aws_security_group.lambda_sg.id]
  #   }
}

resource "aws_lambda_event_source_mapping" "notification_lambda_sqs" {
  event_source_arn = aws_sqs_queue.notification_sqs.arn
  function_name    = aws_lambda_function.notification_lambda.arn
  batch_size       = 10
  enabled          = true
}

// Policies
resource "aws_iam_role" "lambda_role" {
  name = "LambdaRole"
  assume_role_policy = jsondecode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_role_sqs_policy" {
  name = "AllowSQSPermissions"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage"
        ],
        Resource = aws_sqs_queue.notification_sqs.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_role_logs_policy" {
  name = "LambdaRolePolicy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode(({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Resource = "*",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      }
    ]
  }))
}

resource "aws_iam_role_policy" "lambda_ses_policy" {
  name = "AllowSESSendEmail"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}