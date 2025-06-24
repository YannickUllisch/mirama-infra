output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}
output "private_rds_subnet_id" {
  value = module.vpc.private_rds_subnet_id
}

output "private_sqs_subnet_id" {
  value = module.vpc.private_sqs_subnet_id
}