resource "aws_instance" "bastion" {

  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "backend" {

  ami                    = var.backend_ami
  instance_type          = var.backend_instance_type
  subnet_id              = var.private_subnet_id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [var.backend_sg_id]

  tags = {
    Name = "BackendHost"
  }
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}
