# variables
variable "project" {}
variable "environment" {}

variable "main_vpc_cidr_block" {}
variable "secondary_vpc_cidr_blocks" {}

variable "az_set" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "db_private_subnets" {}

variable "enable_natgw" {}
