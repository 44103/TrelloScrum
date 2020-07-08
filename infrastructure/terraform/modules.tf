module "task_lambda" {
  source          = "./modules/lambda"
  prefix          = var.prefix
  project         = var.project
  context         = "task"
  trello_api_key  = var.trello_api_key
  trello_token    = var.trello_token
  trello_board_id = var.trello_task_board_id
  slack_url       = var.slack_url
}

module "story_lambda" {
  source          = "./modules/lambda"
  prefix          = var.prefix
  project         = var.project
  context         = "story"
  trello_api_key  = var.trello_api_key
  trello_token    = var.trello_token
  trello_board_id = var.trello_story_board_id
  slack_url       = var.slack_url
}

module "task_api_gateway" {
  source     = "./modules/api_gateway"
  region     = var.region
  prefix     = var.prefix
  project    = var.project
  context    = "task"
  lambda_arn = module.task_lambda.arn
}

module "story_api_gateway" {
  source     = "./modules/api_gateway"
  region     = var.region
  prefix     = var.prefix
  project    = var.project
  context    = "story"
  lambda_arn = module.story_lambda.arn
}