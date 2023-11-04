variable "rds_databases_list" {
  type        = list(string)
  description = "List of mysql databases needs to be created"
}

variable "project" {}
variable "environment" {}
variable "vpc_id" {}
variable "rds_subnet_ids" {}
variable "rds_az_set" {}

variable "rds_instace" {
  default = "db.t3.micro"
}

variable "rds_disk_size" {}
variable "rds_username" {}
variable "rds_password" {}
