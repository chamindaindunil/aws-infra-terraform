# Outputs
output "vpc_id" {
  value = local.vpc_id
}

output "pvt_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "pub_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "bastion_pub_subnet_id" {
  value = aws_subnet.public_subnet[0].id
}

output "db_pvt_subnet_ids" {
  value = aws_subnet.db_private_subnet.*.id
}

output "eks_endpoint_sg_id" {
  value = aws_security_group.eks_endpoint.id
}