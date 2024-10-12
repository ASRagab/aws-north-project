locals {
  subnet_count = 4
}

module "apigateway" {
  source = "../../modules/apigateway"
}

module "fargate" {
  source                          = "../../modules/fargate"
  environment                     = var.environment
  aws_account_id                  = var.account_id
  service_bus_bootstrap_brokers   = module.msk.msk_cluster_bootstrap_brokers
  private_subnets                 = module.network.private_subnet_ids
  security_groups                 = [module.network.msk_security_group_id, module.network.fargate_security_group_id]
  missouri_services_image_tag     = var.missouri_services_image_tag
  missouri_services_sizing        = var.missouri_services_sizing
  kms_key_arn                     = module.kms.key_arn
  region                          = var.region_name
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
