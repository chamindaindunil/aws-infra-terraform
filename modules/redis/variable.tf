variable "project" {}
variable "environment" {}
variable "vpc_id" {}
variable "redis_subnet_ids" {}
variable "redis_az_set" {}
variable "redis_instance" {}
variable "redis_password" {
  sensitive = true
}
variable "snapshot_retention_limit" {}
variable "eks_subnets" {}
variable "bastion_private_ip" {}