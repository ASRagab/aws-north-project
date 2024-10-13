data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

module "dev" {
  source                           = "./environments/dev"
  account_id                       = data.aws_caller_identity.current.account_id
  region_name                      = data.aws_region.current.name
  domain_name                      = var.domain_name
  environment                      = var.environment
  topic_name                       = var.topic_name
  missouri_services_image_tag      = var.missouri_services_image_tag
  missouri_services_sizing         = var.missouri_services_sizing
  api_gateway_throttle_burst_limit = var.api_gateway_throttle_burst_limit
  api_gateway_throttle_rate_limit  = var.api_gateway_throttle_rate_limit
  api_gateway_quota_limit          = var.api_gateway_quota_limit
  api_gateway_quota_period         = var.api_gateway_quota_period
  cognito_pool_name                = var.cognito_pool_name
  cognito_client_name              = var.cognito_client_name
  cognito_username                 = var.cognito_username
  cognito_user_password            = var.cognito_user_password
}
