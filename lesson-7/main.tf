provider "aws" { region = var.region }


module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  availability_zones= var.azs
  vpc_name = "lesson-7-vpc"
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


provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token = module.eks.cluster_token
}


provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token = module.eks.cluster_token
  }
}