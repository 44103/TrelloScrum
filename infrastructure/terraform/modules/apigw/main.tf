resource "aws_api_gateway_rest_api" "main" {
  name = "${var.prefix}_${var.project}_${var.context}"

  binary_media_types = [
    "*/*",
  ]
}

data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  path        = "/"
}

resource "aws_api_gateway_method" "any" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = data.aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = data.aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.any.http_method

  # Lambda プロキシ統合
  type = "AWS_PROXY"

  # Lambda へは POST のみ対応
  integration_http_method = "POST"

  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "proxy"
}

resource "aws_api_gateway_resource" "proxy_target" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.proxy.id
  path_part   = "{target+}"
}

resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.proxy_target.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_lambda" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.proxy_target.id
  http_method = aws_api_gateway_method.proxy_any.http_method

  # Lambda プロキシ統合
  type = "AWS_PROXY"

  # Lambda へは POST のみ対応
  integration_http_method = "POST"

  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_lambda_permission" "lambda" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path within API Gateway REST API.
  # source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/${aws_api_gateway_method.any.http_method}${data.aws_api_gateway_resource.root.path}"
}

resource "aws_api_gateway_deployment" "production" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.proxy_lambda,
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "prod"

  # API Gatewayの変更時に再デプロイさせるためのハック
  stage_description = "setting file hash = ${md5(file("./modules/apigw/main.tf"))}"
}
