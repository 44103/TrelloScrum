resource "aws_iam_role" "lambda" {
  name               = "${var.prefix}_${var.project}_${var.context}_lambda"
  assume_role_policy = file("./modules/lambda/assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "aws_lambda_basic_execution_attach" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
