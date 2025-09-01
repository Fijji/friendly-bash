output "backend_bucket_name" {
  value = module.s3_backend.bucket_name
  description = "S3 bucket for Terraform state"
}


output "backend_dynamodb_table" {
  value = module.s3_backend.dynamodb_table_name
  description = "DynamoDB table for state locking"
}


output "vpc_id" {
  value = module.vpc.vpc_id
  description = "VPC ID"
}


output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
  description = "IDs of public subnets"
}


output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
  description = "IDs of private subnets"
}


output "internet_gateway_id" {
  value = module.vpc.igw_id
  description = "Internet Gateway ID"
}


output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
  description = "NAT Gateway ID"
}


output "ecr_repository_url" {
  value = module.ecr.repository_url
  description = "ECR repository URL"
}