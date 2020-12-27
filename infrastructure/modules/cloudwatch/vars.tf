# 命名規則
variable "aws_name" {
  description = "AWS Consoleで表示されるリソース名"
}

variable "content" {
  description = "リソース名のcontent"
  default     = ""
}

variable "cron" {}

# リソース
variable "lambda" {
  type = map(string)
}

locals {
  aws_name = var.content == "" ? var.aws_name : join(
    "_", [var.aws_name, var.content]
  )
}