variable "path_part" {
  type        = string
  description = "The last path segment of this API resource"
}

variable "http_method" {
  type        = string
  description = "The HTTP method for the API Gateway method (e.g., GET, POST, PUT)"
}

variable "integration_http_method" {
  type        = string
  description = "The integration HTTP method specifying how API Gateway will interact with the back end"
}

variable "lambda_function_invoke_arn" {
  type        = string
  description = "The ARN to be used for invoking the associated Lambda Function"
}

variable "status_codes" {
  type = list(object({
    status_code       = string
    selection_pattern = string
  }))
  description = "List of HTTP status codes for the API Gateway method responses"
}

variable "rest_api_id" {
  type        = string
  description = "The ID of the REST API"
}

variable "parent_id" {
  type        = string
  description = "The ID of the parent API Gateway resource"
}

variable "stage_name" {
  type        = string
  description = "The name of the stage"
}

variable "source_arn" {
  type        = string
  description = "The ARN of the API Gateway"
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
}

variable "cognito_authorizer_id" {
  type        = string
  description = "The ID of the Cognito Authorizer"
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
