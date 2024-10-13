variable "api_definitions" {
  type = list(object({
    path_part               = string
    http_method             = string
    integration_http_method = string
    status_codes = list(object({
      status_code       = string
      selection_pattern = string
    }))
    lambda_function_invoke_arn = string
    lambda_function_name       = string
  }))
}

variable "stage_name" {
  type        = string
  description = "The name of the stage"
}

variable "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  type        = string
}

variable "throttle_burst_limit" {
  description = "The burst limit for the API Gateway usage plan"
  type        = number
}

variable "throttle_rate_limit" {
  description = "The rate limit for the API Gateway usage plan"
  type        = number
}

variable "quota_limit" {
  description = "The quota limit for the API Gateway usage plan"
  type        = number
}

variable "quota_period" {
  description = "The period for the API Gateway usage plan"
  type        = string
}
