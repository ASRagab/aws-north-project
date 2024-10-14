output "msk_cluster_arn" {
  value = aws_msk_cluster.service_bus.arn
}

output "msk_cluster_name" {
  value = aws_msk_cluster.service_bus.cluster_name
}

output "msk_cluster_bootstrap_brokers" {
  value = data.aws_msk_bootstrap_brokers.service_bus.bootstrap_brokers_sasl_iam
}

output "msk_cluster_uuid" {
  description = "The UUID of the MSK cluster"
  value       = aws_msk_cluster.service_bus.cluster_uuid
}
