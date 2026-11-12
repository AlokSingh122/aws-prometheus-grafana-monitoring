resource "aws_ecs_cluster" "main" {
  name = "monitoring-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name = "monitoring-ecs-cluster"
  }
}
