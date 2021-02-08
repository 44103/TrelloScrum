module "lambda_story" {
  source   = "../modules/lambda"
  aws_name = local.aws_name
  content  = "story"
  iam_role = module.iam_lambda.arn
  envs = merge(
    var.trello_base_env,
    var.trello_board_env,
    var.slack_env
  )
  layers = [
    module.lambdalayer.arn
  ]
}

module "apigw_story" {
  source    = "../modules/apigw/method"
  apigateway = module.apigateway
  content   = "story"
  lambda    = module.lambda_story
}