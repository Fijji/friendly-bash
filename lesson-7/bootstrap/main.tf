terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}


provider "aws" {
  region = var.region
}


module "s3_backend" {
  source = "../modules/s3-backend"
  bucket_name = var.bucket_name
  table_name = var.lock_table
}


output "bucket_name" { value = module.s3_backend.bucket_name }
output "dynamodb_table" { value = module.s3_backend.dynamodb_table_name }