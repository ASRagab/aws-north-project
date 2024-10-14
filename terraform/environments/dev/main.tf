locals {
  subnet_count = 4
}

module "apigateway" {
  source = "../../modules/apigateway"
  api_definitions = [
    {
      path_part               = "msk"
      http_method             = "POST"
      integration_http_method = "POST"
      status_codes = [
        {
          status_code       = "200"
          selection_pattern = ""
        },
        {
          status_code       = "400"
          selection_pattern = "4\\d{2}"
        },
        {
          status_code       = "500"
          selection_pattern = "5\\d{2}"
        }
      ]
      lambda_function_invoke_arn = module.lambda.msk_producer_lambda_invoke_arn
      lambda_function_name       = module.lambda.msk_producer_lambda_name
    }
  ]
  stage_name           = "dev"
  user_pool_arn        = module.cognito.user_pool_arn
  throttle_burst_limit = var.api_gateway_throttle_burst_limit
  throttle_rate_limit  = var.api_gateway_throttle_rate_limit
  quota_limit          = var.api_gateway_quota_limit
  quota_period         = var.api_gateway_quota_period
}

module "cognito" {
  source        = "../../modules/cognito"
  pool_name     = var.cognito_pool_name
  client_name   = var.cognito_client_name
  username      = var.cognito_username
  user_password = var.cognito_user_password
}

module "db" {
  source               = "../../modules/db"
  database_definitions = var.database_definitions
  vpc_id               = module.network.vpc_id
  vpc_cidr_block       = module.network.vpc_ipv4_cidr
  private_subnet_ids   = module.network.private_subnet_ids
  availability_zones   = var.availability_zones
}

module "fargate" {
  source                        = "../../modules/fargate"
  service_definitions           = var.service_definitions
  environment                   = var.environment
  aws_account_id                = var.account_id
  service_bus_bootstrap_brokers = module.msk.msk_cluster_bootstrap_brokers
  private_subnets               = module.network.private_subnet_ids
  security_groups               = [module.network.msk_security_group_id, module.network.fargate_security_group_id]
  kms_key_arn                   = module.kms.key_arn
  region                        = var.region_name
}

module "firehose" {
  source                  = "../../modules/firehose"
  msk_firehose_bucket_arn = module.storage.msk_firehose_bucket_arn
  msk_cluster_arn         = module.msk.msk_cluster_arn
}

module "kms" {
  source      = "../../modules/kms"
  account_id  = var.account_id
  region_name = var.region_name
}

module "lambda" {
  source                = "../../modules/lambda"
  account_id            = var.account_id
  msk_bootstrap_brokers = module.msk.msk_cluster_bootstrap_brokers
  subnet_ids            = module.network.private_subnet_ids
  region                = var.region_name
  msk_cluster_arn       = module.msk.msk_cluster_arn
  msk_cluster_uuid      = module.msk.msk_cluster_uuid
  topic_name            = var.topic_name
  security_group_ids    = [module.network.msk_security_group_id]
  msk_cluster_name      = module.msk.msk_cluster_name
}

module "lb" {
  source            = "../../modules/lb"
  account_id        = var.account_id
  region_name       = var.region_name
  vpc_id            = module.network.vpc_id
  vpc_ipv4_cidr     = module.network.vpc_ipv4_cidr
  vpc_ipv6_cidr     = module.network.vpc_ipv6_cidr
  subnet_ids        = module.network.private_subnet_ids
  public_zone_id    = module.network.public_zone_id
  public_zone_name  = module.network.public_zone_name
  private_zone_name = module.network.private_zone_name
  private_zone_id   = module.network.private_zone_id
  subnet_count      = local.subnet_count
}

module "msk" {
  source              = "../../modules/msk"
  vpc_id              = module.network.vpc_id
  msk_subnet_ids      = module.network.private_subnet_ids
  msk_security_groups = [module.network.msk_security_group_id]
}

module "network" {
  source       = "../../modules/network"
  account_id   = var.account_id
  region_name  = var.region_name
  kms_key_arn  = module.kms.key_arn
  domain_name  = var.domain_name
  subnet_count = local.subnet_count
}

module "storage" {
  source = "../../modules/storage"
}
