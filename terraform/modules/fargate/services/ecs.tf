locals {
  missouri_services_sizes = {
    small = {
      cpu    = "512"
      memory = "1024"
    }
    medium = {
      cpu    = "1024"
      memory = "2048"
    }
    large = {
      cpu    = "2048"
      memory = "4096"
    }
    extra = {
      cpu    = "4096"
      memory = "8192"
    }
  }
}

resource "aws_cloudwatch_log_group" "missouri_services_ecs_log_group" {
  name              = "/${var.environment}/ecs/${var.service_name}"
  retention_in_days = 7
}

resource "aws_ecs_service" "missouri_services" {
  name            = "${var.service_name}-${var.environment}"
  cluster         = var.cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.missouri_services.arn
  desired_count   = var.desired_count

  network_configuration {
    assign_public_ip = true
    subnets          = var.private_subnets
    security_groups  = var.security_groups
  }

  propagate_tags = "TASK_DEFINITION"

  tags = {
    "tenant" = "missouri"
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.missouri_services.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 60
  }
}

resource "aws_ecs_task_definition" "missouri_services" {
  family                   = "${var.service_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = coalesce(lookup(local.missouri_services_sizes, var.sizing, "medium").cpu, "512")
  memory                   = coalesce(lookup(local.missouri_services_sizes, var.sizing, "medium").memory, "1024")
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.service_name}-${var.environment}"
      image     = "${aws_ecr_repository.missouri_services.repository_url}:${var.image_tag}"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.missouri_services_ecs_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "${var.service_name}-${var.environment}"
        }
      }

      healthCheck = {
        command  = ["CMD-SHELL", "test \"$(missouri-services status --output yaml | grep -E '^state')\" = \"state: 2\""]
        interval = 60
        retries  = 5
        timeout  = 5
      }

      environment = [
        {
          name  = "SERVICE_BUS_BOOTSTRAP_BROKERS"
          value = var.service_bus_bootstrap_brokers
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  tags = {
    "tenant" = "missouri"
  }
}
