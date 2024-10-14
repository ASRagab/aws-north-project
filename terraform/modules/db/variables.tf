variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "The availability zones for the database"
  type        = list(string)
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