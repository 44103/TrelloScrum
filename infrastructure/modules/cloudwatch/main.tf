resource "aws_cloudwatch_event_rule" "_" {
  name                = var.content == "" ? var.aws_name : join("_", [var.aws_name, var.content])
  schedule_expression = var.cron
}

resource "aws_cloudwatch_event_target" "_" {
  rule      = "${aws_cloudwatch_event_rule._.name}"
  arn       = var.lambda_arn
  target_id = var.content == "" ? var.aws_name : join("_", [var.aws_name, var.content])
}
