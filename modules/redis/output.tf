output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.redis[0].primary_endpoint_address
}

output "redis_secondary_endpoint" {
  value = aws_elasticache_replication_group.redis[0].reader_endpoint_address
}