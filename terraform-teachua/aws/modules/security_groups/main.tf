resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH from bastion CIDR"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from bastion CIDR"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.bastion_cidr]
  }

ingress {
    description = "HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend" {
  name        = "backend-sg"
  description = "Allow SSH from Bastion SG"
  vpc_id      = var.vpc_id

  ingress {
    description                   = "SSH from bastion sg"
    from_port                   = 22
    to_port                     = 22
    protocol                    = "tcp"
    security_groups             = [aws_security_group.bastion.id]
  }
  
# App port 8080 від Bastion
  ingress {
    description      = "App port 8080 from Bastion"
    from_port        = 8080
    to_port          = 8080
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
  description = "Allow MariaDB from backend SG"
  vpc_id      = var.vpc_id

  ingress {
    description                   = "MariaDB from backend sg"
    from_port                   = 3306
    to_port                     = 3306
    protocol                    = "tcp"
    security_groups             = [aws_security_group.backend.id]
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
