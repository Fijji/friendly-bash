module "vpc" {
  source = "../lesson-7/modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "rds" {
  source = "./modules/rds"

  use_aurora    = false
  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.private_subnet_ids

  engine         = "postgres"
  engine_version = "14"
  instance_class = "db.t3.medium"
  multi_az       = false

  database_name = "appdb"
  username      = "appuser"
  password      = var.db_master_password

  tags = { Project = "lesson-db-module" }
}

