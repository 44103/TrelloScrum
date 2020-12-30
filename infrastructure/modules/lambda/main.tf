data "archive_file" "_" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "../dist/source.zip"
}

resource "aws_lambda_function" "_" {
  function_name    = local.aws_name
  role             = var.iam_role
  runtime          = "python3.8"
  handler          = "index_${var.content}.lambda_handler"
  timeout          = 10
  filename         = data.archive_file._.output_path
  source_code_hash = data.archive_file._.output_base64sha256
  layers = var.layers

  environment {
    variables = local.envs
  }
}
