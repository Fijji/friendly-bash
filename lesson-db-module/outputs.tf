output "rds_outputs" {
  value = {
    db_engine                  = module.rds.db_engine
    db_port                    = module.rds.db_port
    db_security_group_id       = module.rds.db_security_group_id
    db_subnet_group_name       = module.rds.db_subnet_group_name
    parameter_group_name       = module.rds.parameter_group_name
    cluster_parameter_group    = try(module.rds.cluster_parameter_group_name, null)
    rds_instance_id            = try(module.rds.rds_instance_id, null)
    rds_instance_endpoint      = try(module.rds.rds_instance_endpoint, null)
    rds_instance_port          = try(module.rds.rds_instance_port, null)
    aurora_cluster_id          = try(module.rds.aurora_cluster_id, null)
    aurora_reader_endpoint     = try(module.rds.aurora_reader_endpoint, null)
    aurora_writer_endpoint     = try(module.rds.aurora_writer_endpoint, null)
  }
}

