module "iam_lambda" {
  source   = "../modules/iam/lambda"
  aws_name = local.aws_name
}

module "lambdalayer" {
  source = "../modules/lambdalayer"
  # content = "pippkgs"
}

module "apigateway" {
  source = "../modules/apigw"
  aws_name = local.aws_name
}

module "apigateway_deployment" {
  source = "../modules/apigw/deployment"
  apigateway = module.apigateway
  depends_on = [
    module.apigw_task,
    module.apigw_story
  ]
}