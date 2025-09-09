variable "region" { type = string }
variable "cluster_name" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }
variable "ecr_repo_name" { type = string }