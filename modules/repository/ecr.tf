resource "aws_ecr_repository" "ecr" {
  name                 = "mirama-${var.environment}-application-repository"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

