
variable "account_id" {
  type        = string
  description = "The AWS account ID"
}

variable "region_name" {
  type        = string
  description = "The AWS region name"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "vpc_ipv4_cidr" {
  type        = string
  description = "The IPv4 CIDR block of the VPC"
}

variable "vpc_ipv6_cidr" {
  type        = string
  description = "The IPv6 CIDR block of the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the load balancer"
}

variable "public_zone_id" {
  type        = string
  description = "The ID of the public Route53 zone"
}

variable "public_zone_name" {
  type        = string
  description = "The name of the public Route53 zone"
}

variable "private_zone_name" {
  type        = string
  description = "The name of the private Route53 zone"
}

variable "private_zone_id" {
  type        = string
  description = "The ID of the private Route53 zone"
}

variable "subnet_count" {
  type        = number
  description = "The number of subnets"
}
