data "archive_file" "source_code" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./dist/source.zip"
}

resource "aws_lambda_function" "main" {
  function_name    = "${var.prefix}_${var.project}"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.8"
  handler          = "index.lambda_handler"
  timeout          = 10
  filename         = data.archive_file.source_code.output_path
  source_code_hash = data.archive_file.source_code.output_base64sha256

  environment {
    variables = {
      trello_api_key  = var.trello_api_key
      trello_token    = var.trello_token
      trello_board_id = var.trello_board_id
      TZ              = "Asia/Tokyo"
      slack_url = var.slack_url
    }
  }
}
