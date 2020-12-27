variable "aws_name" {
  description = "リソース名"
}

variable "lambda" {
  type = map(string)
}

variable "path_part" {}

variable "stage_name" {
  default = "prod"
}

variable "content" {
  description = "リソース名のcontent"
  default = ""
}

locals {
  aws_name = var.content == "" ? var.aws_name : join(
    "_", [var.aws_name, var.content]
  )
}