resource "aws_ecs_cluster" "nextjs_cluster" {
  name = "mirama-${var.environment}-ecs-cluster"
}

resource "aws_security_group" "ecs_sg" {
  name        = "mirama-${var.environment}-ecs-sg"
  vpc_id      = var.vpc_id
  description = "Allow HTTP for NextJS app"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

