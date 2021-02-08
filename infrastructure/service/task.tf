module "lambda_task" {
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

module "apigw_task" {
  source    = "../modules/apigw/method"
  apigateway = module.apigateway
  content   = "task"
  lambda    = module.task_lambda
}

module "cloudwatch_task" {
  source   = "../modules/cloudwatch"
  aws_name = local.aws_name
  content  = "task"
  cron     = "cron(30 2 ? * MON-FRI *)"
  lambda   = module.cron_lambda
}

module "lambda_cron_lunch_break" {
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