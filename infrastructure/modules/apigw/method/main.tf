
resource "aws_api_gateway_resource" "_" {
  path_part   = var.content
  parent_id   = var.apigateway.root_resource_id
  rest_api_id = var.apigateway.rest_api_id
}

resource "aws_api_gateway_method" "_" {
  rest_api_id   = var.apigateway.rest_api_id
  resource_id   = aws_api_gateway_resource._.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "_" {
  rest_api_id             = var.apigateway.rest_api_id
  resource_id             = aws_api_gateway_resource._.id
  http_method             = aws_api_gateway_method._.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda.invoke_arn
}

resource "aws_lambda_permission" "_" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigateway.execution_arn}/*/${aws_api_gateway_method._.http_method}${aws_api_gateway_resource._.path}"
}