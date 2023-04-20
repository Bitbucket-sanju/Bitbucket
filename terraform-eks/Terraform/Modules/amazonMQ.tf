resource "aws_mq_broker" "mq_broker" {
  name     = "my-mq-broker"
  engine_type = "ActiveMQ"
  engine_version = "5.15.14"
  deployment_mode = "SINGLE_INSTANCE"

  users = [
    {
      username = "admin"
      password = "admin"
    }
  ]