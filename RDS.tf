


/////////////////////////////////////////RDS////////////////////////////////////////////////

# Create Database Subnet Group
# terraform aws db subnet group
resource "aws_db_subnet_group" "database-subnet-group" {
  name         = "${var.app_name}-database-subnet"
  subnet_ids   = [aws_subnet.private-subnet.id]
  description  = "Subnets for Database Instance"

  tags   = {
    Name = "${var.app_name}-Database-Subnets"
  }
}







//////////////////////////////////Seceret manager///////////////////////////////////////////////
resource "random_password" "master"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  name = "${var.app_name}-db-password1"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

//////////////////////////////////RDS///////////////////////////////////////////////////////////

data "aws_secretsmanager_secret" "password" {
  name = "${var.app_name}-db-password1"

}

data "aws_secretsmanager_secret_version" "password" {
  secret_id = data.aws_secretsmanager_secret.password
}


resource "aws_db_instance" "stanely-rds" {
  instance_class          = "db.t2.micro"
  skip_final_snapshot     = true
  availability_zone       = "us-east-1a"
  identifier              = "mysql07db"
  username                = "admin"

  db_subnet_group_name    = aws_db_subnet_group.database-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.stanely-sg.id]
}
