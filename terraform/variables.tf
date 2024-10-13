variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "region_name" {
  description = "The AWS region name"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the environment"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "missouri_services_image_tag" {
  description = "The image tag for Missouri services"
  type        = string
}

variable "missouri_services_sizing" {
  description = "Sizing configurations for Missouri services"
  type = map(object({
    cpu    = string
    memory = string
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
