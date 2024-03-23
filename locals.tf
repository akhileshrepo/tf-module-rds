locals {
  tags    = merge(var.tags, { tf-module-name = "rds" }, { env = var.env })
  name_prefix = "${var.env}-${var.rds_type}-rds"
}