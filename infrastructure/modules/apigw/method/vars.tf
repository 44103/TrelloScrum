variable "lambda" {
  type = map(string)
}

variable "apigateway" {
  type = map(string)
}

variable "content" {
  description = "リソース名のcontent"
  default = ""
}
