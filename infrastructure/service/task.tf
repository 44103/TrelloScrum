module "task_lambda" {
  source   = "../modules/lambda"
  aws_name = local.aws_name
  content  = "task"
  iam_role = module.iam_lambda.arn
  envs = merge(
    var.trello_base_env,
    var.trello_board_env
  )
  layers = [
    module.lambdalayer.arn
  ]
}

module "task_apigw" {
  source    = "../modules/apigw/method"
  apigateway = module.apigateway
  content   = "task"
  lambda    = module.task_lambda
}

module "task_cloudwatch" {
  source   = "../modules/cloudwatch"
  aws_name = local.aws_name
  content  = "task"
  cron     = "cron(30 2 ? * MON-FRI *)"
  lambda   = module.cron_lambda
}

module "cron_lambda" {
  source   = "../modules/lambda"
  aws_name = local.aws_name
  content  = "cron"
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