############################################################
# RDS Resources for Tony Blair DevOps Assessment
############################################################

resource "aws_db_subnet_group" "main" {
  name       = "tonyblair-db-subnet-group"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "tonyblair-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "tonyblair-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict in production!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tonyblair-rds-sg"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "tonyblair-db"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "15.3"
  instance_class          = "db.t3.micro"
  db_name                 = "tonyblair"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  skip_final_snapshot     = true

  tags = {
    Name = "tonyblair-db"
  }
}