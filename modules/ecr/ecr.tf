resource "aws_ecr_repository" "mirama_frontend" {
  name                 = "mirama-frontend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

