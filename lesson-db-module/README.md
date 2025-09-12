# lesson-db-module

Універсальний `modules/rds` для створення або стандартної RDS інстанси, або Aurora кластера `use_aurora`.

- use_aurora = false → створюється `aws_db_instance` 
- use_aurora = true  → створюється `aws_rds_cluster` + `aws_rds_cluster_instance` 

Також створює: `DB Subnet Group`, `Security Group`.

## Використання:
```hcl
module "rds" {
  source = "./modules/rds"

  use_aurora = false 

  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.private_subnet_ids

  engine         = "postgres"           
  engine_version = "14"
  instance_class = "db.t3.medium"
  multi_az       = false                

  database_name = "appdb"
  username      = "appuser"
  password      = var.db_master_password

  allowed_cidr_blocks        = ["10.0.0.0/16"]
  allowed_security_group_ids = []

  allocated_storage       = 20     
  backup_retention_period = 7
  deletion_protection     = true
  publicly_accessible     = false
  custom_port             = null   
  parameter_overrides     = {}
  name_prefix             = "rds"
  tags                    = { Project = "lesson-db-module" }
}
```

## Aurora PostgreSQL:

```hcl
module "rds" {
  source = "./modules/rds"

  use_aurora    = true
  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.private_subnet_ids

  engine         = "aurora-postgresql"
  engine_version = "14"
  instance_class = "db.r6g.large"

  database_name = "appdb"
  username      = "appuser"
  password      = var.db_master_password
}
```

## Inputs:
- use_aurora (bool, default `false`): Aurora (`true`) або RDS (`false`).
- vpc_id (string, required): ID VPC для `Security Group`.
- db_subnet_ids (list(string), required): Приватні підмережі для `DB Subnet Group`.
- engine (string, default `"postgres"`): `postgres`, `mysql`, `aurora-postgresql`, `aurora-mysql`.
- engine_version (string, default `"14"`): Версія БД.
- instance_class (string, default `"db.t3.medium"`): Type instance.
- multi_az (bool, default `false`): Multi-AZ
- database_name (string, default `"appdb"`): БД.
- username (string, default `"appuser"`): root-користувач.
- password (string, sensitive, required): Пароль.
- allocated_storage (number, default `20`): Розмір для RDS.
- backup_retention_period (number, default `7`): Дні зберігання бекапів.
- deletion_protection (bool, default `true`): Захист від видалення.
- publicly_accessible (bool, default `false`): Публічний доступ до інстансу.
- allowed_cidr_blocks (list(string), default `[]`): CIDR для ingress до порту БД.
- allowed_security_group_ids (list(string), default `[]`): SG, яким дозволено доступ.
- custom_port (number, default `null`): порт; якщо null — 5432 (PG) або 3306 (MySQL).
- name_prefix (string, default `"rds"`): Префікс ресурсів.
- tags (map(string), default `{}`): Теги ресурсів.

## Outputs:

- db_engine
- db_port
- db_security_group_id
- db_subnet_group_name
- parameter_group_name
- cluster_parameter_group_name 
- rds_instance_id, rds_instance_endpoint, rds_instance_port 
- aurora_cluster_id, aurora_reader_endpoint, aurora_writer_endpoint

## Vars:

- Тип БД: `use_aurora` : `true` (Aurora) або `false` (RDS).
- Двигун: `engine` : `postgres` / `mysql` / `aurora-postgresql` / `aurora-mysql`.
- Версія: `engine_version`.
- Клас:   `instance_class`.

