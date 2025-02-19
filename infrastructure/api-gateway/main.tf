resource "aws_apigatewayv2_api" "api" {
  name          = "http-api-gateway"
  protocol_type = "HTTP"
}

/* resource "aws_apigatewayv2_integration" "get_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda get call"
  integration_method        = "GET"
  integration_uri           = var.get_lambda_invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_integration" "post_integration" {
  api_id           = aws_apigatewayv2_api.example.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda post call"
  integration_method        = "POST"
  integration_uri           = var.post_lambda_invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"
}
 */