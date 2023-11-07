resource "aws_elasticache_replication_group" "redis" {
  count                      = (var.environment == "prod" || var.environment == "stg") ? 1 : 0
  engine                     = "redis"
  engine_version             = "6.x"
  automatic_failover_enabled = var.environment == "prod" ? true : false
  multi_az_enabled           = var.environment == "prod" ? true : false
  # preferred_cache_cluster_azs   = var.redis_az_set
  replication_group_id = "${var.project}-redis"
  description          = "Redis Instance"
  node_type            = var.redis_instance
  num_cache_clusters   = var.environment == "prod" ? 2 : 1
  parameter_group_name = "default.redis6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_grp.name
  security_group_ids   = [aws_security_group.redis.id]
  # auth_token                    = var.redis_password
  # transit_encryption_enabled    = true
  maintenance_window       = "tue:02:00-tue:03:00"
  snapshot_retention_limit = var.snapshot_retention_limit

  # lifecycle {
  #   ignore_changes = [number_cache_clusters]
  # }
}