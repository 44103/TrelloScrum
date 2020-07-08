# 環境
variable "region" {}

# 命名規則
variable "prefix" {
  description = "リソース名のPrefix"
}
variable "project" {
  description = "プロジェクト名"
}
variable "context" {
  description = "リソース名のContext"
}

# リソース
variable "lambda_arn" {}