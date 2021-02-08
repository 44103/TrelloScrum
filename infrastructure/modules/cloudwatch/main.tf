resource "aws_cloudwatch_event_rule" "_" {
  name                = local.aws_name
  schedule_expression = var.cron
}

resource "aws_cloudwatch_event_target" "_" {
  rule      = aws_cloudwatch_event_rule._.name
  arn       = var.lambda.arn
  target_id = local.aws_name
}

resource "aws_lambda_permission" "_" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule._.arn
}