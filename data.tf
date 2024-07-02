data "aws_ssm_parameter" "master_username" {
  name = "docdb.${var.env}.master_username"
}

data "aws_ssm_parameter" "master_password" {
  name = "docdb.${var.env}.master_password"
}

data "aws_ssm_parameter" "database_name" {
  name = "docdb.${var.env}.database_name"
}