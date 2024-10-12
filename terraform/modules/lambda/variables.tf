# Variables
variable "msk_cluster_arn" {
  description = "The ARN of the MSK cluster"
  type        = string
}

variable "msk_bootstrap_brokers" {
  description = "The list of MSK broker addresses"
  type        = string
}

variable "msk_cluster_uuid" {
  description = "The UUID of the MSK cluster"
  type        = string
}

variable "msk_cluster_name" {
  description = "The name of the MSK cluster"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the Lambda function"
  type        = list(string)
}

variable "security_group_ids" {
  description = "The list of security group IDs for the Lambda function"
  type        = list(string)
}

variable "topic_name" {
  description = "The name of the MSK topic"
  type        = string
}

variable "region" {
  description = "The region of the MSK cluster"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

