resource "aws_api_gateway_resource" "missouri_api_root" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "missouri_api_proxy_post" {
  rest_api_id      = var.rest_api_id
  resource_id      = aws_api_gateway_resource.missouri_api_root.id
  http_method      = var.http_method
  authorization    = "AWS_IAM"
  api_key_required = true
}

resource "aws_api_gateway_method_settings" "missouri_api_method_settings" {
  rest_api_id = var.rest_api_id
  stage_name  = var.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    caching_enabled = false
  }
}

resource "aws_api_gateway_integration" "missouri_lambda_integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.missouri_api_root.id
  http_method             = aws_api_gateway_method.missouri_api_proxy_post.http_method
  integration_http_method = var.integration_http_method
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn
}

resource "aws_api_gateway_method_response" "response" {
  count       = length(var.status_codes)
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.missouri_api_root.id
  http_method = aws_api_gateway_method.missouri_api_proxy_post.http_method
  status_code = var.status_codes[count.index].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.missouri_api_proxy_post]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  count             = length(var.status_codes)
  rest_api_id       = var.rest_api_id
  resource_id       = aws_api_gateway_resource.missouri_api_root.id
  http_method       = aws_api_gateway_method.missouri_api_proxy_post.http_method
  status_code       = var.status_codes[count.index].status_code
  selection_pattern = var.status_codes[count.index].selection_pattern

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_method_response.response]
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.missouri_lambda_integration]
  rest_api_id = var.rest_api_id
  stage_name  = var.stage_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "apigateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.source_arn
}

resource "aws_api_gateway_usage_plan" "missouri_usage_plan" {
  name        = "missouri-defaultusage-plan"
  description = "Default Usage plan for the missouri API"

  api_stages {
    api_id = var.rest_api_id
    stage  = var.stage_name
  }

  throttle_settings {
    burst_limit = var.throttle_burst_limit
    rate_limit  = var.throttle_rate_limit
  }

  quota_settings {
    limit  = var.quota_limit
    period = var.quota_period
  }
}

resource "aws_api_gateway_api_key" "missouri_api_key" {
  name    = "missouri-api-key"
  enabled = true
}

resource "aws_api_gateway_usage_plan_key" "missouri_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.missouri_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.missouri_usage_plan.id
}

resource "aws_api_gateway_usage_plan" "missouri_flash_usage_plan" {
  name        = "missouri-flash-usage-plan"
  description = "Flash Usage plan for the missouri API"

  api_stages {
    api_id = var.rest_api_id
    stage  = var.stage_name
  }

  throttle_settings {
    burst_limit = var.throttle_burst_limit * 100
    rate_limit  = var.throttle_rate_limit * 100
  }
}

resource "aws_api_gateway_api_key" "missouri_flash_api_key" {
  name    = "missouri-flash-api-key"
  enabled = true
}

resource "aws_api_gateway_usage_plan_key" "missouri_flash_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.missouri_flash_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.missouri_flash_usage_plan.id
}
