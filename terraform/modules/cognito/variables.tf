variable "pool_name" {
  description = "The name of the Cognito User Pool"
  type        = string
}

variable "client_name" {
  description = "The name of the Cognito User Pool Client"
  type        = string
}

variable "callback_urls" {
  default     = ["https://example.com"]
  description = "The callback URLs for the Cognito User Pool Client"
  type        = list(string)
}

variable "logout_urls" {
  default     = ["https://missouri.com"]
  description = "The logout URLs for the Cognito User Pool Client"
  type        = list(string)
}

variable "username" {
  description = "The username for the Cognito User"
  type        = string
}

variable "user_password" {
  description = "The password for the Cognito User"
  type        = string
  sensitive   = true
}

variable "id_token_validity" {
  description = "The validity of the ID token, units are hours, which can be overriden by setting the token_validity_units variable"
  type        = number
  default     = 12
}
