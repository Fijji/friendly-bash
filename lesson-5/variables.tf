variable "aws_region" {
  description = "AWS region to deploy resources"
  type = string
  default = "us-west-2"
}

variable "backend_bucket_name" {
  description = "S3 bucket used as Terraform backend"
  type        = string
}

variable "backend_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  type        = string
  default     = "terraform-locks"
}

