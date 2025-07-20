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
