output "bastion_ip" {
  value = aws_instance.ec2.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.ec2.private_ip
}