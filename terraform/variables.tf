variable "domain_name" {
  description = "The domain name for the environment"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "service_definitions" {
  description = "missouri service fargate definitions"
  type = list(object({
    service_name  = string
    image_tag     = string
    sizing        = string
    desired_count = number
  }))
}

variable "topic_name" {
  description = "The name of the MSK topic"
  type        = string
}

variable "cognito_pool_name" {
  description = "The name of the Cognito user pool"
  type        = string
}

variable "cognito_client_name" {
  description = "The name of the Cognito client"
  type        = string
}

variable "cognito_username" {
  description = "The username for the Cognito user"
  type        = string
}

variable "cognito_user_password" {
  description = "The password for the Cognito user"
  type        = string
  sensitive   = true
}

variable "api_gateway_throttle_burst_limit" {
  description = "The API Gateway throttle burst limit"
  type        = number
}

variable "api_gateway_throttle_rate_limit" {
  description = "The API Gateway throttle rate limit"
  type        = number
}

variable "api_gateway_quota_limit" {
  description = "The API Gateway quota limit"
  type        = number
}

variable "api_gateway_quota_period" {
  description = "The API Gateway quota period"
  type        = string
}

variable "database_definitions" {
  description = "The definitions for the databases"
  type = list(object({
    db_master_username = string
    instance_count     = number
    cluster_identifier = string
    database_name      = string
  }))
}
