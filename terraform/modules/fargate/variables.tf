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

variable "kms_key_arn" {
  description = "The ARN of the KMS key"
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

variable "service_bus_bootstrap_brokers" {
  description = "The service bus bootstrap brokers (i.e. AWS MSK bootstrap brokers)"
  type        = string
}

variable "service_definitions" {
  description = "The service definitions"
  type = list(object({
    service_name  = string
    desired_count = number
    image_tag     = string
    sizing        = string
  }))
}
