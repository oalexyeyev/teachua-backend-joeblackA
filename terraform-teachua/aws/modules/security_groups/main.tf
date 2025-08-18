resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH and HTTP access to bastion host"
  vpc_id      = var.vpc_id

  # SSH from allowed CIDR
  ingress {
    description = "SSH from bastion CIDR"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.bastion_cidr]
  }

  # Squid proxy from backend
  ingress {
    description = "Squid proxy from backend"
    from_port   = var.squid_port
    to_port     = var.squid_port
    protocol    = "tcp"
    cidr_blocks = [var.backend_cidr]
  }

  # HTTP from all
  ingress {
    description = "HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend" {
  name        = "backend-sg"
  description = "Allow SSH and app traffic from Bastion SG"
  vpc_id      = var.vpc_id

  # SSH from bastion
  ingress {
    description      = "SSH from bastion SG"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion.id]
  }

  # App port from bastion
  ingress {
    description      = "App port from Bastion"
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "Allow database traffic from backend SG"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Database access from backend SG"
    from_port        = var.db_port
    to_port          = var.db_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "backend_sg_id" {
  value = aws_security_group.backend.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}
