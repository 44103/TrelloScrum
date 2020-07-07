module "lambda" {
  source          = "./modules/lambda"
  prefix          = var.prefix
  trello_api_key  = var.trello_api_key
  trello_token    = var.trello_token
  trello_board_id = var.trello_board_id
}

module "api_gateway" {
  source     = "./modules/api_gateway"
  region     = var.region
  prefix     = var.prefix
  lambda_arn = module.lambda.arn
}