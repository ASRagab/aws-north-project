resource "aws_api_gateway_account" "missouri_api" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn
}

resource "aws_api_gateway_rest_api" "missouri_api" {
  name        = "missouri-api"
  description = "API for Missouri Lambda Endpoints"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

# For Testing purposes
resource "aws_api_gateway_authorizer" "cognito" {
  name          = "cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.missouri_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.user_pool_arn]
}


module "gateway_resources" {
  for_each = {
    for index, definition in var.api_definitions : index => definition
  }
  source                     = "./gateway_resources"
  path_part                  = each.value.path_part
  http_method                = each.value.http_method
  integration_http_method    = each.value.integration_http_method
  lambda_function_invoke_arn = each.value.lambda_function_invoke_arn
  status_codes               = each.value.status_codes
  rest_api_id                = aws_api_gateway_rest_api.missouri_api.id
  parent_id                  = aws_api_gateway_rest_api.missouri_api.root_resource_id
  stage_name                 = var.stage_name
  source_arn                 = "${aws_api_gateway_rest_api.missouri_api.execution_arn}/*"
  lambda_function_name       = each.value.lambda_function_name
  cognito_authorizer_id      = aws_api_gateway_authorizer.cognito.id
  throttle_burst_limit       = var.throttle_burst_limit
  throttle_rate_limit        = var.throttle_rate_limit
  quota_limit                = var.quota_limit
  quota_period               = var.quota_period

  depends_on = [aws_api_gateway_account.missouri_api]
}
