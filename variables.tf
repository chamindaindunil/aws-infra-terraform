variable "project" {}
variable "environment" {}
variable "profile" {}

variable "aws_region" {}

##VPC
variable "main_vpc_cidr_block" {
  default = "10.23.0.0/24"
}

variable "secondary_vpc_cidr_blocks" {
  default = ["10.124.1.0/24"]
}

variable "az_set" {
  default = ["us-east-1c"]
}

variable "private_subnets" {
  default = ["10.23.0.0/25", "10.23.0.128/27"]
}

variable "db_private_subnets" {
  default = ["10.23.0.128/27"]
}

variable "public_subnets" {
  default = ["10.124.1.0/27"]
}

variable "enable_natgw" {}

##Bastion
variable "bastion_instance_type" {}
variable "bastion_ami" {}
variable "bastion_disk_size" {}

##EKS
variable "node_count" {
  default = 1
}

variable "eks_instance_types" {
  default = ["t3a.medium"]
}

variable "eks_ami_type" {
  default = "AL2_x86_64"
}

variable "eks_version" {}

##RDS
variable "rds_instace" {
  default = "db.t3.micro"
}

variable "rds_az_set" {}
variable "rds_disk_size" {}

variable "rds_username" {}
variable "rds_password" {
  sensitive = true
}

variable "rds_databases_list" {}

# CF
variable "http_apigw_url" {}
variable "cf_custom_domain" {}
variable "cf_enable_acm_cert" {}
variable "managed_rules" {}

# Redis
variable "redis_instance" {}
variable "redis_password" {
  sensitive = true
}
variable "snapshot_retention_limit" {}