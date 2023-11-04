#Endpoint for EC2 API
resource "aws_security_group" "endpoint_ec2" {
  name   = "endpoint-ec2"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "endpoint_ec2_443" {
  security_group_id = aws_security_group.endpoint_ec2.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnets, var.public_subnets)
}

locals {
  vpc_endpoint_subnet_ids = var.environment == "prod" ? aws_subnet.private_subnet.*.id : [aws_subnet.private_subnet[0].id]
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-southeast-1.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.vpc_endpoint_subnet_ids

  security_group_ids = [
    aws_security_group.endpoint_ec2.id,
  ]
}

#Endpoint for ECR APIs
resource "aws_security_group" "endpoint_ecr" {
  name   = "endpoint-ecr"
  vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "endpoint_ecr_443" {
  security_group_id = aws_security_group.endpoint_ecr.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnets, var.public_subnets)
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-southeast-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.vpc_endpoint_subnet_ids

  security_group_ids = [
    aws_security_group.endpoint_ecr.id,
  ]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-southeast-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.vpc_endpoint_subnet_ids

  security_group_ids = [
    aws_security_group.endpoint_ecr.id,
  ]
}

#Endpoint for STS/ALB/QLDB APIs
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-southeast-1.sts"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.vpc_endpoint_subnet_ids

  security_group_ids = [
    aws_security_group.endpoint_ec2.id,
  ]
}

resource "aws_vpc_endpoint" "elasticloadbalancing" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-southeast-1.elasticloadbalancing"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.vpc_endpoint_subnet_ids

  security_group_ids = [
    aws_security_group.endpoint_ec2.id,
  ]
}

resource "aws_vpc_endpoint" "qldb_session" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-southeast-1.qldb.session"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.vpc_endpoint_subnet_ids

  security_group_ids = [
    aws_security_group.endpoint_ec2.id,
  ]
}

resource "aws_vpc_endpoint" "git_codecommit" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-southeast-1.git-codecommit"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = local.vpc_endpoint_subnet_ids

  security_group_ids = [
    aws_security_group.endpoint_ec2.id,
  ]
}

#Endpoint for s3 API
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.ap-southeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.rt_private.id
}

#Endpoint for dynamodb
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.ap-southeast-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.rt_private.id
}

