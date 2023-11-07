resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project}-http-apigw"
  protocol_type = "HTTP"
}

# resource "aws_apigatewayv2_integration" "api" {
#   api_id           = aws_apigatewayv2_api.main.id
#   integration_type = "HTTP_PROXY"

#   integration_method = "ANY"
#   integration_uri    = "https://example.com/{proxy}"
# }

# resource "aws_apigatewayv2_route" "api" {
#   api_id    = aws_apigatewayv2_api.main.id
#   route_key = "ANY /example/{proxy+}"

#   target = "integrations/${aws_apigatewayv2_integration.api.id}"
# }