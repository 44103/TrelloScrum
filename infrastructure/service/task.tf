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
  lambda    = module.lambda_task
}

module "lambda_cron" {
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

module "cloudwatch_task_lunchbreak" {
  source   = "../modules/cloudwatch"
  aws_name = local.aws_name
  content  = "task_lunchbreak"
  cron     = "cron(30 2 ? * MON-FRI *)"
  lambda   = module.lambda_cron
}

module "cloudwatch_task_closed" {
  source   = "../modules/cloudwatch"
  aws_name = local.aws_name
  content  = "task_closed"
  cron     = "cron(30 7 ? * MON-FRI *)"
  lambda   = module.lambda_cron
}