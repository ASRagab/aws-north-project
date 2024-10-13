account_id                  = "123456789012"
region_name                 = "us-west-2"
domain_name                 = "example.com"
environment                 = "dev"
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
topic_name          = "missouri-services-dev"
cognito_pool_name   = "missouri-services-dev"
cognito_client_name = "missouri-services-client-dev"

api_gateway_throttle_burst_limit = 50
api_gateway_throttle_rate_limit  = 100
api_gateway_quota_limit          = 100000000
api_gateway_quota_period         = "MONTH"

