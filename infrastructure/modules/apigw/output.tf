output "rest_api_id" {
  value = aws_api_gateway_rest_api._.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api._.root_resource_id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api._.execution_arn
}
