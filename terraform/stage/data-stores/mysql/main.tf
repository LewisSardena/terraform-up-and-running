provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!    
    bucket = "terraform-up-and-running-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"
    # Replace this with your DynamoDB table name!    
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}


resources "aws_db_instance" "example" {
  indetifier_prefix  = "terraform-up-and-running"
  engine             = "mysql"
  allowcated_storage = 10
  instance_class     = "db.t2.micro"
  name               = "example_database"
  username           = "admin"

  # How should we set the password?
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-stage"
}