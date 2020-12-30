# resource "null_resource" "pip_install" {
#   provisioner "local-exec" {
#     command = <<EOS
#     pip install -r requirements.txt -t "../../src/layers/${var.content}"
#     EOS
#   }
# }

data "archive_file" "libs" {
  type        = "zip"
  source_dir = "../src/layers"
  output_path = "../dist/${var.content}.zip"
}

resource "aws_lambda_layer_version" "_" {
  filename = data.archive_file.libs.output_path
  layer_name = var.content
  compatible_runtimes = ["python3.8"]
}