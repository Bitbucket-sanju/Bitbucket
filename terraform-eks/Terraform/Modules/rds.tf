resource "aws_db_instance" "example" {
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  allocated_storage = 10
  name              = "eks-db"

  # Database credentials
  username = "admin"
  password = "sanju8796"

  # Backup configuration
  backup_retention_period = 7
  backup_window           = "02:00-03:00"

}

