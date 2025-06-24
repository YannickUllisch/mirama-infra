output "rds_connection_url" {
  description = "RDS connection URL"
  value = "${aws_db_instance.rds.username}:${aws_db_instance.rds.password}@${aws_db_instance.rds.endpoint}/${aws_db_instance.rds.identifier}"
  sensitive = true
}