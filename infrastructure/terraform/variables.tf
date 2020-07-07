variable "region" {
  description = "リージョン"
  default     = "ap-northeast-1"
}

variable "prefix" {
  description = "リソース名のPrefix"
}

variable "suffix" {
  description = "リソース名のSuffix"
}

variable "trello_api_key" {
  description = "Trello APIキー"
}

variable "trello_token" {
  description = "Trelloトークン"
}

variable "trello_board_id" {
  description = "TrelloボードID"
}