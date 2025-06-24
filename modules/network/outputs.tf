output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_rds_subnet_id" {
  value = aws_subnet.private_rds_subnet.id
}

output "private_sqs_subnet_id" {
  value = aws_subnet.private_sqs_subnet
}