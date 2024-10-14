output "cluster_endpoint" {
  value = aws_rds_cluster.missouri_services_cluster.endpoint
}

output "cluster_reader_endpoint" {
  value = aws_rds_cluster.missouri_services_cluster.reader_endpoint
}

output "cluster_id" {
  value = aws_rds_cluster.missouri_services_cluster.id
}

output "cluster_arn" {
  value = aws_rds_cluster.missouri_services_cluster.arn
}

output "cluster_engine" {
  value = aws_rds_cluster.missouri_services_cluster.engine
}

output "cluster_engine_version" {
  value = aws_rds_cluster.missouri_services_cluster.engine_version
}

output "cluster_database_name" {
  value = aws_rds_cluster.missouri_services_cluster.database_name
}

output "cluster_db_subnet_group_name" {
  value = aws_rds_cluster.missouri_services_cluster.db_subnet_group_name
}
