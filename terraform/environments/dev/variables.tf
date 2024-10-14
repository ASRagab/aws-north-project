variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "region_name" {
  description = "The AWS region name"
  type        = string
}

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "environment" {
  description = "The environment"
  type        = string
}

variable "topic_name" {
  description = "The name of the MSK topic"
  type        = string
}

variable "cognito_pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
}

variable "cognito_client_name" {
  description = "The name of the Cognito User Pool Client"
  type        = string
}

variable "cognito_username" {
  description = "The username for the Cognito User"
  type        = string
}

variable "cognito_user_password" {
  description = "The password for the Cognito User"
  type        = string
  sensitive   = true
}

variable "callback_urls" {
  description = "The callback URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["https://example.com"]
}

variable "logout_urls" {
  description = "The logout URLs for the Cognito User Pool Client"
  type        = list(string)
  default     = ["https://missouri.com"]
}

variable "id_token_validity" {
  description = "The validity of the ID token in hours"
  type        = number
  default     = 12
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

variable "service_definitions" {
  description = "missouri service fargate definitions"
  type = list(object({
    service_name  = string
    image_tag     = string
    sizing        = string
    desired_count = number
  }))
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

variable "availability_zones" {
  description = "The availability zones for the database"
  type        = list(string)
}
