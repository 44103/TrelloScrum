# 環境
variable "region" {}

# 命名規則
variable "aws_name" {
  description = "AWS Consoleで表示されるリソース名"
}
variable "content" {
  description = "リソース名のcontent"
  default = ""
}

# リソース
variable "lambda_arn" {}
