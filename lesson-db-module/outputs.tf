output "vpc_id" { value = try(module.vpc.vpc_id, null) }
output "private_subnet_ids" { value = try(module.vpc.private_subnet_ids, []) }
output "rds" {
  value = {
    engine              = module.rds.db_engine
    port                = module.rds.db_port
    security_group_id   = module.rds.db_security_group_id
    subnet_group_name   = module.rds.db_subnet_group_name
    parameter_group     = module.rds.parameter_group_name
    cluster_param_group = try(module.rds.cluster_parameter_group_name, null)
    instance_id         = try(module.rds.rds_instance_id, null)
    endpoint            = try(module.rds.rds_instance_endpoint, null)
    aurora_cluster_id   = try(module.rds.aurora_cluster_id, null)
    aurora_reader       = try(module.rds.aurora_reader_endpoint, null)
    aurora_writer       = try(module.rds.aurora_writer_endpoint, null)
  }
}

