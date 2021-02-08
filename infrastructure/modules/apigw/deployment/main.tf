
resource "aws_api_gateway_deployment" "_" {
  rest_api_id       = var.apigateway.rest_api_id
  stage_name        = var.stage_name
  stage_description = "HASH=${md5(file("../modules/apigw/main.tf"))}"
}
