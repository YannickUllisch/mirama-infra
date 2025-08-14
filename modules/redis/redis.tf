resource "aws_security_group" "redis_sg" {
  name   = "mirama-${var.environment}-redis-sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ingress for debugging, should be removed"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = [var.vpc_cidr]
    description = "Only allow traffic from mirama app VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "mirama-${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id = "mirama-${var.environment}-redis"

  security_group_ids = [aws_security_group.redis_sg.id]
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  engine_version       = "7.1"
  parameter_group_name = "default.redis7"
}