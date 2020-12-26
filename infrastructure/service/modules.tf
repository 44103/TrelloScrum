module "iam_lambda" {
  source = "../modules/iam/lambda"
  aws_name = local.aws_name
}

module "task_lambda" {
  source = "../modules/lambda"
  aws_name = local.aws_name
  content  = "task"
  iam_role = module.iam_lambda.arn
  envs = merge(
    var.trello_base_env,
    var.trello_board_env
  )
}

module "story_lambda" {
  source = "../modules/lambda"
  aws_name = local.aws_name
  content  = "story"
  iam_role = module.iam_lambda.arn
  envs = merge(
    var.trello_base_env,
    var.trello_board_env,
    var.slack_env
  )
}

module "task_apigw" {
  source = "../modules/apigw"
  region = var.region
  aws_name = local.aws_name
  content    = "task"
  lambda_arn = module.task_lambda.arn
}

module "story_apigw" {
  source = "../modules/apigw"
  region = var.region
  aws_name = local.aws_name
  content    = "story"
  lambda_arn = module.story_lambda.arn
}

module "cron_lambda" {
  source = "../modules/lambda"
  aws_name = local.aws_name
  content  = "cron"
  iam_role = module.iam_lambda.arn
  envs = merge(
    var.trello_base_env,
    var.trello_board_env,
    var.slack_env
  )
}

module "task_cloudwatch" {
  source = "../modules/cloudwatch"
  aws_name = local.aws_name
  content    = "task"
  cron = "cron(0 0 1 * ? *)"
  lambda_arn = module.cron_lambda.arn
}
