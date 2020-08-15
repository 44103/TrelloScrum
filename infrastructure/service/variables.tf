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
variable "trello_task_env" {
  description = "TrelloTaskBoard用環境変数"
  type        = map(string)
}
variable "trello_story_env" {
  description = "TrelloStoryBoard環境変数"
  type        = map(string)
}

variable "slack_env" {
  description = "Slack環境変数"
  type        = map(string)
}
