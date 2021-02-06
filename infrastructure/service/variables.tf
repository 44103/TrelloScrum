# 環境
variable "region" {
  description = "リージョン"
  default     = "ap-northeast-1"
}

# 命名規則
variable "prefix" {
  description = "リソース名のPrefix"
}
variable "project" {
  description = "プロジェクト名"
}
variable "suffix" {
  description = "リソース名のSuffix"
}

# API
variable "trello_base_env" {
  description = "Trello基本環境変数"
  type        = map(string)
}
variable "trello_board_env" {
  description = "Trelloボード変数"
  type        = map(string)
}

variable "slack_env" {
  description = "Slack環境変数"
  type        = map(string)
}

locals {
  aws_name = join(
    "_", [var.prefix, var.project]
  )
}