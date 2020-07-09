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

# API
variable "trello_api_key" {
  description = "Trello APIキー"
}
variable "trello_token" {
  description = "Trelloトークン"
}
variable "trello_board_id" {
  description = "TrelloボードID"
}
variable "slack_url" {
  description = "SlackのIncomming Webhook URL"
}
variable "slack_mention" {
  description = "SlackのメンションID"
  default = ""
}