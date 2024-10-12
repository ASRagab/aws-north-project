variable "msk_subnet_ids" {
  description = "List of subnet IDs for the MSK cluster"
  type        = list(string)
}

variable "msk_security_groups" {
  description = "List of security group IDs for the MSK cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the MSK cluster"
  type        = string
}