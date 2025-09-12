variable "use_aurora" {
  description = "Whether to create an Aurora cluster (true) or a single RDS instance (false)."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID where the database security group will be created."
  type        = string
}

variable "db_subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "engine" {
  description = "Database engine."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version."
  type        = string
  default     = "14"
}

variable "instance_class" {
  description = "Instance class for RDS instance or Aurora instance."
  type        = string
  default     = "db.t3.medium"
}

variable "multi_az" {
  description = "Whether to deploy Multi-AZ for RDS instance."
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Initial database name."
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Root username."
  type        = string
  default     = "appuser"
}

variable "password" {
  description = "Root password."
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "Allocated storage in GB."
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Number of days to retain backups."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Enable deletion protection."
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Whether the instance should be publicly accessible."
  type        = bool
  default     = false
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the database port."
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Security Group IDs allowed to access the database port."
  type        = list(string)
  default     = []
}

variable "custom_port" {
  description = "Optional custom database port."
  type        = number
  default     = null
}

variable "tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "parameter_overrides" {
  description = "Map of additional/override DB parameters for the created parameter group."
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
  default     = "rds"
}

