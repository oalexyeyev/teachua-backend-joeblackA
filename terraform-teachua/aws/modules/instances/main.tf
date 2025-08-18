resource "aws_instance" "bastion" {
  ami                    = "ami-0de716d6197524dd9" # Amazon Linux 2 us-east-1, заміни якщо потрібно
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "backend" {
  ami                    = "ami-0de716d6197524dd9"
  instance_type          = "t2.micro"
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
