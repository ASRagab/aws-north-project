variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "region_name" {
  description = "The AWS region name"
  type        = string
}

variable "kms_key_arn" {
  description = "The KMS key ARN"
  type        = string
}

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "subnet_count" {
  description = "The number of subnets"
  type        = number
}
