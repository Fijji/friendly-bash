variable "region" { type = string }
variable "cluster_name" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }
variable "ecr_repo_name" { type = string }

variable "jenkins_namespace"  { type = string, default = "ci" }
variable "jenkins_release"    { type = string, default = "jenkins" }
variable "argocd_namespace"   { type = string, default = "argocd" }
variable "argocd_release"     { type = string, default = "argo-cd" }

variable "apps_repo_url"  { type = string }
variable "apps_repo_rev"  { type = string, default = "main" }
variable "apps_repo_path" { type = string, default = "charts/django-app" }
variable "app_namespace"  { type = string, default = "default" }
variable "app_name"       { type = string, default = "django-app" }