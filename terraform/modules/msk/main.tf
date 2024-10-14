locals {
  kafka_version = "3.5.1"
  cluster_name  = "missouri-service-bus"
}

resource "aws_msk_cluster" "service_bus" {
  cluster_name           = local.cluster_name
  kafka_version          = local.kafka_version
  number_of_broker_nodes = length(var.msk_subnet_ids) * 3

  broker_node_group_info {
    instance_type   = "kafka.m5.24xlarge"
    client_subnets  = var.msk_subnet_ids
    security_groups = var.msk_security_groups

    storage_info {
      ebs_storage_info {
        volume_size = 20
      }
    }

    connectivity_info {
      public_access {
        type = "DISABLED"
      }
    }
  }

  client_authentication {
    sasl {
      iam = true
    }
  }

  tags = {
    Name = local.cluster_name
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_broker_logs.name
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "msk_broker_logs" {
  name              = "/aws/msk/${local.cluster_name}/brokers"
  retention_in_days = 14

  tags = {
    Name        = local.cluster_name
    Environment = "dev"
  }
}


data "aws_msk_bootstrap_brokers" "service_bus" {
  cluster_arn = aws_msk_cluster.service_bus.arn
}

data "aws_iam_policy_document" "service_bus_policy" {
  statement {
    sid    = "AllowFirehoseAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = [
      "kafka:DescribeCluster",
      "kafka:DescribeClusterV2",
      "kafka:GetBootstrapBrokers",
      "kafka:CreateVpcConnection",
    ]

    resources = [aws_msk_cluster.service_bus.arn]
  }
}

resource "aws_msk_cluster_policy" "service_bus_policy" {
  cluster_arn = aws_msk_cluster.service_bus.arn
  policy      = data.aws_iam_policy_document.service_bus_policy.json
}

resource "aws_msk_configuration" "service_bus_configuration" {
  name              = "service-bus-configuration"
  kafka_versions    = [local.kafka_version]
  server_properties = <<-PROPERTIES
    auto.create.topics.enable = true
    delete.topic.enable = true
  PROPERTIES
}
