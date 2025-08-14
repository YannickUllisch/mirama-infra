resource "aws_ecs_cluster" "ecs_cluster" {
  name = "mirama-${var.environment}-ecs-cluster"
}

resource "aws_security_group" "ecs_sg" {
  name        = "mirama-${var.environment}-ecs-sg"
  vpc_id      = var.vpc_id
  description = "Allow HTTP for NextJS app"

  // Allow HTTP traffic on port 3000
  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  // Allow SSH Access for debugging
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "mirama-ecs-${var.environment}-"
  image_id      = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type = "t2.micro"
  key_name      = "mirama-ecs-ssh-key"

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    arn = var.ecs_instance_profile_arn
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ecs_sg.id]
    subnet_id                   = var.public_subnet_ids[0]
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name_prefix               = "mirama-ecs-asg-${var.environment}-"
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  vpc_zone_identifier       = var.public_subnet_ids
  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}


resource "aws_ecs_task_definition" "mirama_app_task" {
  family                   = "mirama-nextjs-task"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.ecs_exec_role_arn
  task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"


  container_definitions = jsonencode([
    {
      name      = "${var.container_name}"
      image     = "${var.ecr_repo_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = "${var.container_port}"
          hostPort      = "${var.container_port}"
        }
      ]

      environment = [
        {
          name  = "NEXT_PUBLIC_ENV"
          value = "prod"
        },
        {
          name  = "AUTH_TRUST_HOST"
          value = "true"
        },
        {
          name  = "RESEND_EMAIL_FROM"
          value = "onboarding@resend.dev"
        },
        {
          name  = "NEXTAUTH_URL"
          value = "https://mirama-ecs.yannickullisch.com"
        },
        {
          name  = "NEXT_PUBLIC_BASE_URL"
          value = "https://mirama-ecs.yannickullisch.com"
        },
        {
          name  = "AWS_COGNITO_REGION"
          value = "eu-west-1"
        },
        {
          name  = "POSTGRES_PRISMA_URL"
          value = var.POSTGRES_PRISMA_URL
        },
        {
          name  = "POSTGRES_URL_NON_POOLING"
          value = var.POSTGRES_URL_NON_POOLING
        },
        {
          name  = "REDIS_URL"
          value = var.REDIS_URL
        },
        {
          name  = "NEXTAUTH_SECRET"
          value = var.NEXTAUTH_SECRET
        },
        {
          name  = "RESEND_API_KEY"
          value = var.RESEND_API_KEY
        },
        {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = var.AWS_SECRET_ACCESS_KEY
        },
        {
          name  = "AWS_ACCESS_KEY_ID"
          value = var.AWS_ACCESS_KEY_ID
        },
        {
          name  = "NOTIFICATION_TOPIC_ARN"
          value = var.NOTIFICATION_TOPIC_ARN
        },
        {
          name  = "COGNITO_DOMAIN_URL"
          value = var.COGNITO_DOMAIN_URL
        },
        {
          name  = "COGNITO_CLIENT_ID"
          value = var.COGNITO_CLIENT_ID
        },
        {
          name  = "COGNITO_ISSUER"
          value = var.COGNITO_ISSUER
        },
        {
          name  = "COGNITO_USER_POOL_ID"
          value = var.COGNITO_USER_POOL_ID
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = "eu-west-1"
          "awslogs-stream-prefix" = "mirama-ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "ecs" {
  name            = "mirama-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.mirama_app_task.arn
  launch_type     = "EC2"
  desired_count   = 1

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
  }

  depends_on = [
    aws_alb_listener.https_listener,
    aws_alb_listener.http_listener,
  ]

  load_balancer {
    target_group_arn = aws_alb_target_group.app_alb_tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
}
