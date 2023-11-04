resource "aws_elasticache_subnet_group" "redis_subnet_grp" {
  name       = "${var.project}-redis-subnetgrp"
  subnet_ids = var.redis_subnet_ids
}

resource "aws_security_group" "redis" {
  name        = "redis-sg"
  description = "Allow redis from worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = concat(var.eks_subnets, ["${var.bastion_private_ip}/32"]) #["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

