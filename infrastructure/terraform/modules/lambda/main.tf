data "archive_file" "source_code" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./dist/source.zip"
}

resource "aws_lambda_function" "main" {
  function_name    = "${var.prefix}_${var.project}_${var.context}"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.8"
  handler          = "index_${var.context}.lambda_handler"
  timeout          = 10
  filename         = data.archive_file.source_code.output_path
  source_code_hash = data.archive_file.source_code.output_base64sha256

  environment {
    variables = var.envs
  }
}
