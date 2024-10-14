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

variable "service_bus_bootstrap_brokers" {
  description = "The service bus bootstrap brokers (i.e. AWS MSK bootstrap brokers)"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key"
  type        = string
}

variable "image_tag" {
  description = "The image tag"
  type        = string
}

variable "sizing" {
  description = "The sizing of the service"
  type        = string
}

variable "service_name" {
  description = "The name of the service"
  type        = string
}

variable "desired_count" {
  description = "The desired count of the service"
  type        = number
}

variable "execution_role_arn" {
  description = "The ARN of the execution role"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the task role"
  type        = string
}

variable "cluster_id" {
  description = "The ID of the cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}
