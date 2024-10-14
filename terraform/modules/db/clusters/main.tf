resource "aws_rds_cluster" "missouri_services_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = "15.3"
  database_name           = var.database_name
  master_username         = var.db_master_username
  master_password         = var.db_master_password
  backup_retention_period = 30
  preferred_backup_window = "02:00-03:00"
  skip_final_snapshot     = true

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name

  serverlessv2_scaling_configuration {
    min_capacity = 2
    max_capacity = 128
  }

  tags = {
    Name = var.cluster_identifier
  }

  iam_database_authentication_enabled = true

  availability_zones = var.availability_zones
}

resource "aws_rds_cluster_instance" "missouri_services_cluster_instance" {
  count                = var.instance_count
  identifier           = "${var.cluster_identifier}-${count.index}"
  cluster_identifier   = aws_rds_cluster.missouri_services_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.missouri_services_cluster.engine
  engine_version       = aws_rds_cluster.missouri_services_cluster.engine_version
  db_subnet_group_name = var.db_subnet_group_name
}