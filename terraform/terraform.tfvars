domain_name = "example.com"
environment = "dev"

topic_name          = "missouri-services-dev"
cognito_pool_name   = "missouri-services-dev"
cognito_client_name = "missouri-services-client-dev"

api_gateway_throttle_burst_limit = 50
api_gateway_throttle_rate_limit  = 100
api_gateway_quota_limit          = 100000000
api_gateway_quota_period         = "MONTH"

service_definitions = [
  {
    service_name  = "missouri-service"
    image_tag     = "latest"
    sizing        = "medium"
    desired_count = 4
  }
]

database_definitions = [
  {
    db_master_username = "admin"
    instance_count     = 2
    cluster_identifier = "missouri-cluster"
    database_name      = "missouri-db"
  }
]