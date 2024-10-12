data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

module "dev" {
  source                      = "./environments/dev"
  account_id                  = data.aws_caller_identity.current.account_id
  region_name                 = data.aws_region.current.name
  domain_name                 = "missouri.com"
  environment                 = "dev"
  topic_name                  = "missouri-dev"
  missouri_services_image_tag = "latest"
  missouri_services_sizing = {
    small = {
      cpu    = "512"
      memory = "1024"
    }
    medium = {
      cpu    = "1024"
      memory = "2048"
    }
    large = {
      cpu    = "2048"
      memory = "4096"
    }
  }
}
