variable "environment" {
  description = "The environment name"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "private_subnets" {
  description = "The private subnets"
  type        = list(string)
}

variable "security_groups" {
  description = "Ingest security group for ecs tasks"
  type        = list(string)
}

variable "missouri_services_image_tag" {
  description = "The missouri services docker image tag"
  type        = string
}

variable "missouri_services_sizing" {
  description = "The sizing for the missouri services in ECS"
  type = map(object({
    cpu    = string
    memory = string
  }))
}

variable "service_bus_bootstrap_brokers" {
  description = "The service bus bootstrap brokers (i.e. AWS MSK bootstrap brokers)"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key"
  type        = string
}
