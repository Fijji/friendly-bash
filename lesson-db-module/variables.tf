variable "region" { type = string }

# VPC inputs
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }

# ECR + EKS
variable "ecr_repo_name" { type = string }
variable "cluster_name" { type = string }

# Argo CD apps repo
variable "apps_repo_url" { type = string }
variable "apps_repo_rev" { type = string }
variable "apps_repo_path" { type = string }

# RDS controls
variable "use_aurora" { type = bool, default = false }
variable "engine" { type = string, default = "postgres" }
variable "engine_version" { type = string, default = "14" }
variable "instance_class" { type = string, default = "db.t3.medium" }
variable "multi_az" { type = bool, default = false }
variable "database_name" { type = string, default = "appdb" }
variable "db_username" { type = string, default = "appuser" }
variable "db_password" { type = string, sensitive = true }
variable "allocated_storage" { type = number, default = 20 }
variable "backup_retention_period" { type = number, default = 7 }
variable "deletion_protection" { type = bool, default = true }
variable "publicly_accessible" { type = bool, default = false }
variable "custom_port" { type = number, default = null }
variable "parameter_overrides" { type = map(string), default = {} }
variable "name_prefix" { type = string, default = "rds" }
variable "tags" { type = map(string), default = {} }

