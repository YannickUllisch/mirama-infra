resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  description = "Allow all HTTP/HTTPS traffic from the internet. For ALB, after SSL port 80 should be removed from production. "
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "main" {
  name            = "mirama-${var.environment}-alb"
  internal        = false
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.alb_sg.id]
}

# ALB Listener for HTTP
resource "aws_alb_target_group" "app_alb_tg" {
  name        = "mirama-${var.environment}-ecs-alb-target-group"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    enabled  = true
    path     = "/api/health"
    port     = var.container_port
    interval = 240
  }
}

resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app_alb_tg.arn
  }
}

# ALB Listener for HTTPS
resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn = aws_acm_certificate.main.arn

  default_action {
    target_group_arn = aws_alb_target_group.app_alb_tg.arn
    type             = "forward"
  }
}