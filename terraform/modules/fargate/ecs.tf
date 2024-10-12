resource "aws_cloudwatch_log_group" "missouri_services_ecs_log_group" {
  name              = "/${var.environment}/ecs/missouri-services"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "missouri_services_cluster" {
  name = "missouri-services-${var.environment}"

  configuration {
    execute_command_configuration {
      kms_key_id = var.kms_key_arn
      logging    = "OVERRIDE"


      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.missouri_services_ecs_log_group.name
      }
    }
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "missouri_services" {
  name            = "missouri-services-${var.environment}"
  cluster         = aws_ecs_cluster.missouri_services_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.missouri_services.arn
  desired_count   = 1 # TODO: Variablize

  network_configuration {
    assign_public_ip = true
    subnets          = var.private_subnets
    security_groups  = var.security_groups
  }

  propagate_tags = "TASK_DEFINITION"

  tags = {
    "tenant" = "missouri"
  }
}

resource "aws_ecs_task_definition" "missouri_services" {
  family                   = "missouri-services-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = coalesce(lookup(var.missouri_services_sizing, "medium").cpu, "4096")
  memory                   = coalesce(lookup(var.missouri_services_sizing, "medium").memory, "8192")
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.missouri_services_task.arn

  container_definitions = jsonencode([
    {
      name      = "missouri-services-${var.environment}"
      image     = "${aws_ecr_repository.missouri_services.repository_url}:latest"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.missouri_services_ecs_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "missouri-services-${var.environment}"
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
