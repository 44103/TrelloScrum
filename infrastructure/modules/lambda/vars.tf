# 命名規則
variable "aws_name" {
  description = "AWS Consoleに表示されるリソース名"
}
variable "content" {
  description = "リソース名のcontent"
  default = ""
}

# IAM
variable "iam_role" {
  description = "Lambdaに追加するIAM Role"
}

# API
variable "envs" {
  description = "環境変数"
  type = map(string)
}
