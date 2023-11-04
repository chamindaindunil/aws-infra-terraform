output "config_map_aws_auth" {
  value = module.aws-eks.config_map_aws_auth
}

output "kubeconfig" {
  value = module.aws-eks.kubeconfig
}

output "rds_endpoint" {
  value = module.aws-rds.rds_endpoint
}

output "eks_cluster_name" {
  value = module.aws-eks.eks_cluster_name
}

output "bastion_ip" {
  value = module.bastion.bastion_ip
}

output "s3_bucket_name" {
  value = module.aws-s3.s3_bucket_name
}

output "cf_domain_name" {
  value = module.aws-cf.cf_domain_name
}

output "acm_dns_validation_record" {
  value = module.aws-cf.acm_dns_validation_record
}

output "acm_dns_validation_status" {
  value = module.aws-cf.acm_dns_validation_status
}

output "redis_primary_endpoint" {
  value = module.aws-redis.redis_primary_endpoint
}

output "redis_reader_endpoint" {
  value = module.aws-redis.redis_secondary_endpoint
}