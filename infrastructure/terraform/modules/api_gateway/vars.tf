# 環境
variable "region" {}

# 命名規則
variable "prefix" {
  description = "リソース名のPrefix"
}
variable "project" {
  description = "プロジェクト名"
}

# リソース
variable "lambda_arn" {}