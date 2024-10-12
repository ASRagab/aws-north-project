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

variable "missouri_services_image_tag" {
  description = "The missouri services docker image tag"
  type        = string
}

variable "missouri_services_sizing" {
  description = "The sizing for the missouri services in ECS"
  type = map(object({
    cpu    = string
    memory = string
  }))
}

variable "topic_name" {
  description = "The name of the MSK topic"
  type        = string
}
