variable "prefix" {
  type = "string"
}

variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "elb_subnet_ids" {
  type = "list"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_elb" "rabbitmq" {
  name            = "${var.prefix}-rabbitmq"
  subnets         = "${var.elb_subnet_ids}"
  security_groups = ["${aws_security_group.rabbitmq.id}"]

  listener {
    instance_port     = 5672
    instance_protocol = "tcp"
    lb_port           = 5672
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 5671
    instance_protocol = "tcp"
    lb_port           = 5671
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 5671
    instance_protocol = "tcp"
    lb_port           = 5671
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 1883
    instance_protocol = "tcp"
    lb_port           = 1883
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 8883
    instance_protocol = "tcp"
    lb_port           = 8883
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 61613
    instance_protocol = "tcp"
    lb_port           = 61613
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 61614
    instance_protocol = "tcp"
    lb_port           = 61614
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 15672
    instance_protocol = "tcp"
    lb_port           = 15672
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 15674
    instance_protocol = "tcp"
    lb_port           = 15674
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 3
    timeout             = 3
    target              = "TCP:5671"
    interval            = 5
  }
}

resource "aws_security_group" "rabbitmq" {
  name   = "${var.prefix}-rabbitmq"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "RabbitMQ" {
  type        = "ingress"
  from_port   = 5672
  to_port     = 5672
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "MQTT" {
  type        = "ingress"
  from_port   = 1883
  to_port     = 1883
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "MQTTSSL" {
  type        = "ingress"
  from_port   = 8883
  to_port     = 8883
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "STOMP" {
  type        = "ingress"
  from_port   = 61613
  to_port     = 61613
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "STOMPSSL" {
  type        = "ingress"
  from_port   = 61614
  to_port     = 61614
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "ManagementDashboard" {
  type        = "ingress"
  from_port   = 15672
  to_port     = 15672
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group_rule" "WebSTOMP" {
  type        = "ingress"
  from_port   = 15674
  to_port     = 15674
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

output "rabbitmq_lb_name" {
  value = "${aws_elb.rabbitmq.name}"
}

output "rabbitmq_lb_dns_name" {
  value = "${aws_elb.rabbitmq.dns_name}"
}

output "rabbitmq_security_group" {
  value = "${aws_security_group.rabbitmq.id}"
}
