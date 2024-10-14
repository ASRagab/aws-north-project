variable "db_master_username" {
  description = "The master username for the database"
  type        = string
}

variable "db_master_password" {
  description = "The master password for the database"
  type        = string
}

variable "availability_zones" {
  description = "The availability zones for the database"
  type        = list(string)
}

variable "instance_count" {
  description = "The number of instances for the database"
  type        = number
}

variable "cluster_identifier" {
  description = "The identifier for the cluster"
  type        = string
}

variable "database_name" {
  description = "The name of the database"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security group IDs for the database"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
}