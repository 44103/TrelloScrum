module "story_lambda" {
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

module "story_apigw" {
  source    = "../modules/apigw"
  aws_name  = local.aws_name
  content   = "story"
  lambda    = module.story_lambda
  path_part = "prod"
}