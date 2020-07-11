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
variable "envs" {
  description = "環境変数"
  type = map(string)
}
