module "iam_lambda" {
  source   = "../modules/iam/lambda"
  aws_name = local.aws_name
}

module "lambdalayer" {
  source = "../modules/lambdalayer"
  content = "pippkgs"
}