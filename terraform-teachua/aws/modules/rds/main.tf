resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_db_instance" "mariadb" {
  identifier              = "teachua-db"
  db_name                 = "teachua"     # замість name
  allocated_storage       = 20
  engine                  = "mariadb"
  instance_class          = "db.t3.micro"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.db_sg_id]
  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true

  tags = {
    Name = "TeachUA MariaDB"
  }
}
output "db_endpoint" {
  value = aws_db_instance.mariadb.endpoint
}
