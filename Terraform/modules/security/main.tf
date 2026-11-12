resource "aws_security_group" "ecs" {
  name        = "ecs-instance-sg"
  description = "Access rules for the ECS container host."
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-instance-sg"
  }
}

resource "aws_security_group" "monitoring" {
  name        = "monitoring-server-sg"
  description = "Access rules for the Prometheus and Grafana host."
  vpc_id      = var.vpc_id

  tags = {
    Name = "monitoring-server-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ssh" {
  security_group_id = aws_security_group.ecs.id
  description       = "SSH from the configured administrator IP."
  cidr_ipv4         = var.my_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ecs_app" {
  security_group_id = aws_security_group.ecs.id
  description       = "Application testing from the configured administrator IP."
  cidr_ipv4         = var.my_ip
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 5000
}

resource "aws_vpc_security_group_ingress_rule" "ecs_app_monitoring" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Application and /metrics access from the monitoring host."
  referenced_security_group_id = aws_security_group.monitoring.id
  from_port                    = 5000
  ip_protocol                  = "tcp"
  to_port                      = 5000
}

resource "aws_vpc_security_group_ingress_rule" "ecs_cadvisor" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "cAdvisor access from the monitoring host."
  referenced_security_group_id = aws_security_group.monitoring.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_ingress_rule" "ecs_node_exporter" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Node Exporter access from the monitoring host."
  referenced_security_group_id = aws_security_group.monitoring.id
  from_port                    = 9100
  ip_protocol                  = "tcp"
  to_port                      = 9100
}

resource "aws_vpc_security_group_ingress_rule" "monitoring_ssh" {
  security_group_id = aws_security_group.monitoring.id
  description       = "SSH from the configured administrator IP."
  cidr_ipv4         = var.my_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "monitoring_grafana" {
  security_group_id = aws_security_group.monitoring.id
  description       = "Grafana from the configured administrator IP."
  cidr_ipv4         = var.my_ip
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_ingress_rule" "monitoring_prometheus" {
  security_group_id = aws_security_group.monitoring.id
  description       = "Prometheus from the configured administrator IP."
  cidr_ipv4         = var.my_ip
  from_port         = 9090
  ip_protocol       = "tcp"
  to_port           = 9090
}

resource "aws_vpc_security_group_egress_rule" "ecs_all" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow outbound traffic."
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "monitoring_all" {
  security_group_id = aws_security_group.monitoring.id
  description       = "Allow outbound traffic."
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
