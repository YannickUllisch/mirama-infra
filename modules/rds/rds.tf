resource "aws_security_group" "rds_sg" {
  name = "mirama-${var.environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Ingress for debugging only, should be removed later"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
  }
  
  ingress {
    cidr_blocks = [ var.vpc_cidr ]
    description = "Only allow traffic from app VPC"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
  }
  
  /*
  ingress {
    security_groups = [ aws_security_group.ecs_sg.id ]
    description = "only allow traffic from instances belong to ecs security group"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
  }
  */

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "tcp"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "mirama-${var.environment}-db-subnet-group"
  subnet_ids = [var.rds_subnet_id]
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_db_instance" "rds" {
  engine            = "postgres"
  engine_version    = "15.5" 
  port              = 5432   # PostgreSQL default port

  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "pgadmin"
  password          = random_password.db_password.result

  db_subnet_group_name     = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  publicly_accessible      = false 
  skip_final_snapshot      = true
  storage_encrypted         = false 

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  delete_automated_backups        = false
}