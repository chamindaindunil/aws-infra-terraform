# Create SSH TLS keys
resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

resource "local_file" "bastion_ssh_pvtkey" {
  content         = tls_private_key.public_private_key_pair.private_key_pem
  filename        = "output/${var.project}_bastion_key.pem"
  file_permission = "600"
}

resource "local_file" "bastion_ssh_pubkey" {
  content         = tls_private_key.public_private_key_pair.public_key_openssh
  filename        = "output/${var.project}_bastion.pub"
  file_permission = "600"
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = tls_private_key.public_private_key_pair.public_key_openssh
}