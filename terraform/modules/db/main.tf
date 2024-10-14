resource "aws_db_subnet_group" "aurora" {
  name       = "aurora-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "aurora_sg" {
  name        = "aurora-sg"
  description = "Security group for Aurora Serverless v2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "clusters" {
  source                 = "./clusters"
  for_each               = { for db in var.database_definitions : db.cluster_identifier => db }
  db_master_username     = each.value.db_master_username
  db_master_password     = random_password.db_master_password.result
  availability_zones     = var.availability_zones
  instance_count         = each.value.instance_count
  cluster_identifier     = each.value.cluster_identifier
  database_name          = each.value.database_name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
}

resource "random_password" "db_master_password" {
  length           = 16
  special          = false
}