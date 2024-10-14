resource "aws_cloudwatch_log_group" "missouri_services_cluster_log_group" {
  name              = "/${var.environment}/ecs/cluster"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "missouri_services_cluster" {
  name = "missouri-services-cluster-${var.environment}"

  configuration {
    execute_command_configuration {
      kms_key_id = var.kms_key_arn
      logging    = "OVERRIDE"


      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.missouri_services_cluster_log_group.name
      }
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "services" {
  for_each                      = { for service in var.service_definitions : service.service_name => service }
  source                        = "./services"
  region                        = var.region
  aws_account_id                = var.aws_account_id
  environment                   = var.environment
  kms_key_arn                   = var.kms_key_arn
  private_subnets               = var.private_subnets
  security_groups               = var.security_groups
  service_bus_bootstrap_brokers = var.service_bus_bootstrap_brokers
  service_name                  = each.value.service_name
  desired_count                 = each.value.desired_count
  image_tag                     = each.value.image_tag
  sizing                        = each.value.sizing
  execution_role_arn            = aws_iam_role.ecs_execution_role.arn
  task_role_arn                 = aws_iam_role.missouri_services_task.arn
  cluster_id                    = aws_ecs_cluster.missouri_services_cluster.id
  cluster_name                  = aws_ecs_cluster.missouri_services_cluster.name
}
