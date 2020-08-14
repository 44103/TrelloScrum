module "task_lambda" {
  source  = "./modules/lambda"
  prefix  = var.prefix
  project = var.project
  context = "task"
  envs = merge(
    var.trello_base_env,
    var.trello_task_env
  )
}

module "story_lambda" {
  source  = "./modules/lambda"
  prefix  = var.prefix
  project = var.project
  context = "story"
  envs = merge(
    var.trello_base_env,
    var.trello_story_env,
    var.slack_env
  )
}

module "task_api_gateway" {
  source     = "./modules/apigw"
  region     = var.region
  prefix     = var.prefix
  project    = var.project
  context    = "task"
  lambda_arn = module.task_lambda.arn
}

module "story_api_gateway" {
  source     = "./modules/apigw"
  region     = var.region
  prefix     = var.prefix
  project    = var.project
  context    = "story"
  lambda_arn = module.story_lambda.arn
}
