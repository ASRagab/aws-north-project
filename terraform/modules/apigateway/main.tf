# API Gateway
resource "aws_api_gateway_rest_api" "main" {
  name        = "missouri-api"
  description = "Missouri API Gateway with rate limiting and API keys"
}

# API Gateway Stage
resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "prod"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_method.example, aws_api_gateway_integration.example]
}

# Example Method and Integration (you'll need to adjust these based on your specific needs)
resource "aws_api_gateway_resource" "example" {
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "example"
  rest_api_id = aws_api_gateway_rest_api.main.id
}

resource "aws_api_gateway_method" "example" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
}

resource "aws_api_gateway_integration" "example" {
  http_method = aws_api_gateway_method.example.http_method
  resource_id = aws_api_gateway_resource.example.id
  rest_api_id = aws_api_gateway_rest_api.main.id
  type        = "MOCK"
}

# Usage Plan for Rate Limiting
resource "aws_api_gateway_usage_plan" "main" {
  name = "main-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = aws_api_gateway_stage.main.stage_name
  }

  quota_settings {
    limit  = 1000000
    offset = 0
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 10000
    rate_limit  = 5000
  }
}

# API Key
resource "aws_api_gateway_api_key" "main" {
  name = "main-api-key"
}

# Associate API Key with Usage Plan
resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.main.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.main.id
}

# Enable API Key Required on Method
resource "aws_api_gateway_method_settings" "example" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
