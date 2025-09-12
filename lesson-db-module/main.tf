module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.ecr_repo_name
}

module "eks" {
  source             = "../lesson-7/modules/eks"
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  region             = var.region
}

data "aws_eks_cluster_auth" "this" { name = module.eks.cluster_name }

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

module "rds" {
  source = "./modules/rds"

  use_aurora    = var.use_aurora
  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.private_subnet_ids

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  multi_az       = var.multi_az

  database_name = var.database_name
  username      = var.db_username
  password      = var.db_password

  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  publicly_accessible     = var.publicly_accessible
  custom_port             = var.custom_port
  parameter_overrides     = var.parameter_overrides
  name_prefix             = var.name_prefix
  tags                    = var.tags
}

module "jenkins" {
  source       = "./modules/jenkins"
  namespace    = "jenkins"
  release_name = "jenkins"
  aws_region   = var.region
  ecr_repo_url = module.ecr.repository_url
}

module "argo_cd" {
  source         = "./modules/argo_cd"
  namespace      = "argocd"
  release_name   = "argocd"
  apps_repo_url  = var.apps_repo_url
  apps_repo_rev  = var.apps_repo_rev
  apps_repo_path = var.apps_repo_path
  app_name       = "django-app"
  app_namespace  = "default"
}


