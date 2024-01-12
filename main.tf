resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids
  tags = merge(local.tags, { Name = "${local.name_prefix}-subnet-group" })
}

resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${local.name_prefix}-sg" })

  ingress {
    description = "RDS"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.sg_ingress_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "${local.name_prefix}-pg"
  family = var.engine_family
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${local.name_prefix}-cluster"
  engine                  = var.engine
  engine_version          = var.engine_version
  db_subnet_group_name    = aws_db_subnet_group.main.name
  database_username = data.aws_ssm_parameter.database_username.value
  master_username = data.aws_ssm_parameter.master_username.value
  master_password = data.aws_ssm_parameter.master_password.value
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  db_instance_parameter_group_name = aws_db_parameter_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
  skip_final_snapshot = var.skip_final_snapshot
  tags = merge(local.tags, { Name = "${local.name_prefix}-cluster" })
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "${local.name_prefix}-cluster-instance-${count.index+1}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
}