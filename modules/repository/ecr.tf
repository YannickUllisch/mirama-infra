resource "aws_ecr_repository" "ecr" {
  name                 = "mirama-${var.environment}-application-repository"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Pretty harsh lifecycle policy to ensure low cost and no untagged images
resource "aws_ecr_lifecycle_policy" "remove_untagged" {
  repository = aws_ecr_repository.ecr.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 2
        description  = "Remove untagged images after a day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}