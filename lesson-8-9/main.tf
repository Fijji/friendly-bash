provider "aws" { region = var.region }
data "aws_caller_identity" "current" {}



module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  availability_zones= var.azs
  vpc_name = "lesson-8-9-vpc"
}


module "ecr" {
  source = "./modules/ecr"
  ecr_name = var.ecr_repo_name
  scan_on_push = true
}


module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  region = var.region
}

module "jenkins" {
  source       = "./modules/jenkins"
  namespace    = var.jenkins_namespace
  release_name = var.jenkins_release
  aws_region   = var.region
  ecr_repo_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repo_name}"
}

module "argocd" {
  source        = "./modules/argo_cd"
  namespace     = var.argocd_namespace
  release_name  = var.argocd_release
  apps_repo_url = var.apps_repo_url
  apps_repo_rev = var.apps_repo_rev
  apps_repo_path = var.apps_repo_path
  app_name      = var.app_name
  app_namespace = var.app_namespace
}

