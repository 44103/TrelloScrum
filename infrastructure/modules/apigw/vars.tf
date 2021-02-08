variable "aws_name" {
  description = "リソース名"
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