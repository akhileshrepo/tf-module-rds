data "aws_ssm_parameter" "master_username" {
  name = "rds.${var.env}.master_username"
}


data "aws_ssm_parameter" "master_password" {
  name = "rds.${var.env}.master_password"
}

data "aws_ssm_parameter" "database_name" {
  name = "rds.${var.env}.database_name"
}