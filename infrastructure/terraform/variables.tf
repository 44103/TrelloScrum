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
variable "trello_api_key" {
  description = "Trello APIキー"
}
variable "trello_token" {
  description = "Trelloトークン"
}
variable "trello_task_board_id" {
  description = "TrelloTaskボードID"
}
variable "trello_story_board_id" {
  description = "TrelloStoryボードID"
}

variable "slack_url" {
  description = "SlackのIncomming Webhook URL"
}