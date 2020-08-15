resource "aws_iam_role" "_" {
  name               = join("_", var.content == "" ? [var.aws_name, "lambda"] : [var.aws_name, var.content, "lambda"])
  assume_role_policy = file("../modules/iam/lambda/assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "aws_lambda_basic_execution_attach" {
  role       = aws_iam_role._.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
