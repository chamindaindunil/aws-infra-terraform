resource "aws_db_subnet_group" "rds_subnet_grp" {
  name       = "${var.project}-db-subnetgrp"
  subnet_ids = var.rds_subnet_ids

}

resource "aws_security_group" "rds_mysql" {
  name        = "rds-mysql-sg"
  description = "Allow mysql from worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.vpc_id.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}