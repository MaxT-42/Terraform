provider "aws" {
  region = "eu-central-1"
}

# Generate Password
resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&" // we can to use only this

  keepers = {
    kepeer1 = var.name
    //keperr2 = var.something2
    //keperr3 = var.something3
  }
}

# Store Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Password for DB"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

# Get Password from SSM Parameter Store
data "aws_ssm_parameter" "my_rds_password" {
  name       = "/prod/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}


// Example of Use Password in RDS
resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "prod"
  username             = "administrator"
  password             = data.aws_ssm_parameter.my_rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}

output "rds_password" {
  value = data.aws_ssm_parameter.my_rds_password.value
}
