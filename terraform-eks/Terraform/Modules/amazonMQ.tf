resource "aws_mq_broker" "mqbroker" {
  broker_name = "broker"

  engine_type        = "ActiveMQ"
  engine_version     = "5.15.9"
  host_instance_type = "mq.t2.micro"

  user {
    username = "admin"
    password = "admin123456789"
  }
}