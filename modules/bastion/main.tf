resource "aws_instance" "ec2" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.bastion_subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion_ssh.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size           = var.bastion_disk_size
    volume_type           = "gp2"
  }

  depends_on = [aws_security_group.bastion_ssh]

  lifecycle {
    ignore_changes = [iam_instance_profile]
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.ec2.id
  domain   = "vpc"
}

resource "aws_security_group" "bastion_ssh" {
  name_prefix = "${var.project}-bastion-ssh"
  description = "Allow inbound SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

