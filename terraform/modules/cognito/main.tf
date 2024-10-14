resource "aws_cognito_user_pool" "this" {
  name = var.pool_name
}

resource "aws_cognito_user_pool_client" "this" {
  name                                 = var.client_name
  user_pool_id                         = aws_cognito_user_pool.this.id
  allowed_oauth_flows_user_pool_client = true
  generate_secret                      = false
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["aws.cognito.signin.user.admin", "email", "openid", "profile"]
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers         = ["COGNITO"]

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  enable_token_revocation = true
  id_token_validity       = var.id_token_validity
}

# Test User
resource "aws_cognito_user" "this" {
  user_pool_id = aws_cognito_user_pool.this.id
  username     = var.username
  password     = var.user_password
}
