provider "aws" {
    region = "eu-west-1"
}

module "webserver_cluster" {
    source = "github.com/LewisSardena/terraform-modules//services/webserver-cluster?ref=v0.0.1"

    cluster_name = "webservers-stage"
    db_remote_state_bucket = "bucket_name"
    db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

    instance_type = "t2.micro"
    min_size      = 2
    max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}