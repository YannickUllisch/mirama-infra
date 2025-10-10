data "archive_file" "go_lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda/build/function.zip"
  source {
    content  = <<-EOC
      package main

      import (
        "context"
        "encoding/json"
        "log"

        "github.com/aws/aws-lambda-go/lambda"
      )

      // Handler processes the incoming event, logs it, and returns true.
      func Handler(ctx context.Context, event json.RawMessage) (bool, error) {
        log.Printf("Received event: %s", string(event))
        return true, nil
      }

      func main() {
        lambda.Start(Handler)
      }
    EOC
    filename = "main.go"
  }
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}