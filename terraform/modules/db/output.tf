output "dbs" {
  value = { for cluster in module.clusters : cluster.cluster_id => {
    endpoint             = cluster.cluster_endpoint
    reader_endpoint      = cluster.cluster_reader_endpoint
    cluster_id           = cluster.cluster_id
    arn                  = cluster.cluster_arn
    engine               = cluster.cluster_engine
    engine_version       = cluster.cluster_engine_version
    database_name        = cluster.cluster_database_name
    db_subnet_group_name = cluster.cluster_db_subnet_group_name
    }
  }
}

output "db_master_password" {
  value = random_password.db_master_password.result
  sensitive = true
}
