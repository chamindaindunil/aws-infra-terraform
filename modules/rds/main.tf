resource "aws_db_instance" "mysql" {
  identifier     = "${var.project}-mysql"
  engine         = "mysql"
  engine_version = "8.0"

  allocated_storage = var.rds_disk_size
  storage_type      = "gp2"

  instance_class       = var.rds_instace
  username             = var.rds_username
  password             = var.rds_password
  parameter_group_name = "default.mysql8.0"

  availability_zone      = var.environment != "prod" ? var.rds_az_set : ""
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.rds_mysql.id]

  multi_az            = var.environment == "prod" ? true : false
  publicly_accessible = false
  skip_final_snapshot = var.environment == "prod" ? false : true

  apply_immediately = true
}